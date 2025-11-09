package com.event.servlet;

import com.event.dao.EventDAO;
import com.event.dao.PaymentDAO;
import com.event.dao.RegistrationDAO;
import com.event.model.Event;
import com.event.model.Payment;
import com.event.model.Registration;
import com.google.gson.Gson;
import com.razorpay.Order;
import com.razorpay.RazorpayClient;
import com.razorpay.RazorpayException;
import org.json.JSONObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/createPaymentOrder")
public class PaymentServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    
    // Razorpay Test Credentials (Replace with your actual keys)
    private static final String RAZORPAY_KEY_ID = "rzp_test_Qb9FJurfVV6ULB";
    private static final String RAZORPAY_SECRET = "YN2evifmyeL8T4QYmVresH3k";
    
    private RegistrationDAO registrationDAO = new RegistrationDAO();
    private EventDAO eventDAO = new EventDAO();
    private PaymentDAO paymentDAO = new PaymentDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            // Get registration ID from request
            String regIdParam = request.getParameter("regId");
            if (regIdParam == null || regIdParam.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.write("{\"error\":\"Registration ID is required\"}");
                return;
            }
            
            int registrationId = Integer.parseInt(regIdParam);

            // Get registration and event details
            Registration registration = registrationDAO.getRegistrationById(registrationId);
            if (registration == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.write("{\"error\":\"Registration not found\"}");
                return;
            }
            
            Event event = eventDAO.getEventById(registration.getEventId());
            if (event == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.write("{\"error\":\"Event not found\"}");
                return;
            }
            
            // Amount in paise (multiply by 100 for Razorpay)
            int amount = event.getFee().multiply(new BigDecimal(100)).intValue();

            // Create Razorpay order
            RazorpayClient razorpay = new RazorpayClient(RAZORPAY_KEY_ID, RAZORPAY_SECRET);
            
            JSONObject orderRequest = new JSONObject();
            orderRequest.put("amount", amount);
            orderRequest.put("currency", "INR");
            orderRequest.put("receipt", "reg_" + registrationId);
            orderRequest.put("payment_capture", 1);

            Order order = razorpay.orders.create(orderRequest);
            String orderId = order.get("id");

            // Save payment record in database
            Payment payment = new Payment();
            payment.setRegistrationId(registrationId);
            payment.setPaymentGatewayTxId(orderId);
            payment.setAmount(event.getFee());
            payment.setStatus("initiated");
            
            paymentDAO.createPayment(payment);

            // Return order details to client for payment processing
            Map<String, Object> orderData = new HashMap<>();
            orderData.put("success", true);
            orderData.put("orderId", orderId);
            orderData.put("amount", amount);
            orderData.put("currency", "INR");
            orderData.put("keyId", RAZORPAY_KEY_ID);
            orderData.put("registrationId", registrationId);
            orderData.put("eventName", event.getName());

            out.print(new Gson().toJson(orderData));
            out.flush();

        } catch (SQLException e) {
            System.err.println("Database error in PaymentServlet: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.write("{\"error\":\"Database error occurred\"}");
            
        } catch (RazorpayException e) {
            System.err.println("Razorpay error in PaymentServlet: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.write("{\"error\":\"Payment gateway error occurred\"}");
            
        } catch (NumberFormatException e) {
            System.err.println("Invalid registration ID: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.write("{\"error\":\"Invalid registration ID format\"}");
            
        } catch (Exception e) {
            System.err.println("Unexpected error in PaymentServlet: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.write("{\"error\":\"An unexpected error occurred\"}");
            
        } finally {
            if (out != null) {
                out.close();
            }
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setStatus(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        response.getWriter().write("{\"error\":\"GET method not supported. Use POST.\"}");
    }
}
