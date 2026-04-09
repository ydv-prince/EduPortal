package com.elearn.dto;

import lombok.*;
import java.math.BigDecimal;

@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Builder
public class PaymentDto {

    private Long courseId;
    private BigDecimal amount;
    private String transactionId;
    private String paymentMethod;

    // Razorpay specific fields
    private String razorpayOrderId;
    private String razorpayPaymentId;
    private String razorpaySignature;
}