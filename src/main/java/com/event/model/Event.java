package com.event.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Event model representing university events
 */
public class Event {
    // Primary fields
    private int id;
    private String name;
    private String description;
    private String venue;
    private Timestamp eventDate;
    private Timestamp registrationDeadline;  // ADDED THIS FIELD
    private String eligibility;
    private BigDecimal fee;
    private int capacity;
    private int createdBy;
    private String status;
    private String eventImage;
    
    // Audit fields
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Constructors
    public Event() {}

    // Getters and Setters
    public int getId() { 
        return id; 
    }
    
    public void setId(int id) { 
        this.id = id; 
    }

    public String getName() { 
        return name; 
    }
    
    public void setName(String name) { 
        this.name = name; 
    }

    public String getDescription() { 
        return description; 
    }
    
    public void setDescription(String description) { 
        this.description = description; 
    }

    public String getVenue() { 
        return venue; 
    }
    
    public void setVenue(String venue) { 
        this.venue = venue; 
    }

    public Timestamp getEventDate() { 
        return eventDate; 
    }
    
    public void setEventDate(Timestamp eventDate) { 
        this.eventDate = eventDate; 
    }

    // ADDED THESE METHODS
    public Timestamp getRegistrationDeadline() {
        return registrationDeadline;
    }

    public void setRegistrationDeadline(Timestamp registrationDeadline) {
        this.registrationDeadline = registrationDeadline;
    }

    public String getEligibility() { 
        return eligibility; 
    }
    
    public void setEligibility(String eligibility) { 
        this.eligibility = eligibility; 
    }

    public BigDecimal getFee() { 
        return fee; 
    }
    
    public void setFee(BigDecimal fee) { 
        this.fee = fee; 
    }

    public int getCapacity() { 
        return capacity; 
    }
    
    public void setCapacity(int capacity) { 
        this.capacity = capacity; 
    }

    public int getCreatedBy() { 
        return createdBy; 
    }
    
    public void setCreatedBy(int createdBy) { 
        this.createdBy = createdBy; 
    }

    public String getStatus() { 
        return status; 
    }
    
    public void setStatus(String status) { 
        this.status = status; 
    }

    public String getEventImage() {
        return eventImage;
    }

    public void setEventImage(String eventImage) {
        this.eventImage = eventImage;
    }

    public Timestamp getCreatedAt() { 
        return createdAt; 
    }
    
    public void setCreatedAt(Timestamp createdAt) { 
        this.createdAt = createdAt; 
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    @Override
    public String toString() {
        return "Event{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", venue='" + venue + '\'' +
                ", eventDate=" + eventDate +
                ", registrationDeadline=" + registrationDeadline +
                ", status='" + status + '\'' +
                '}';
    }
}
