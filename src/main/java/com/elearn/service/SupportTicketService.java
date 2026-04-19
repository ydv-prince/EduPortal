package com.elearn.service;

import com.elearn.model.SupportTicket;
import com.elearn.model.enums.TicketStatus;
import com.elearn.repository.SupportTicketRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class SupportTicketService {

    private final SupportTicketRepository ticketRepository;

    @Transactional(readOnly = true)
    public List<SupportTicket> getAllTickets() {
        return ticketRepository.findAll();
    }

    @Transactional(readOnly = true)
    public List<SupportTicket> getTicketsByStatus(String statusStr) {
        try {
            TicketStatus status = TicketStatus.valueOf(statusStr.toUpperCase());
            return ticketRepository.findByStatus(status);
        } catch (IllegalArgumentException e) {
            return getAllTickets(); // Fallback agar galat status aaye
        }
    }

    public void resolveTicket(Long id) {
        SupportTicket ticket = ticketRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Ticket not found"));
        ticket.setStatus(TicketStatus.RESOLVED);
        ticketRepository.save(ticket);
    }
}