package com.komorowski.backend.controller;

import com.komorowski.backend.model.dto.CreatedOrder;
import com.komorowski.backend.service.PaypalService;
import org.springframework.ui.Model;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.net.URI;
import java.net.URISyntaxException;

@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/orders")
@RequiredArgsConstructor
public class OrderController {

    private final PaypalService paypalService;

    @PostMapping
    public String placeOrder(@RequestParam Double totalAmount, HttpServletRequest request){
        final URI returnUrl = buildReturnUrl(request);
        CreatedOrder createdOrder = paypalService.createOrder(totalAmount, returnUrl);
        return "redirect:"+createdOrder.getApprovalLink();
    }

    @GetMapping
    public String orderPage(Model model){
        model.addAttribute("orderId",orderId);
        return "order";
    }

    @GetMapping("/capture")
    public String captureOrder(@RequestParam String token){
        orderId = token;
        paypalService.captureOrder(token);
        return "<html>Payment successful. Click <a href='#' onclick='window.close();return false;'>here</a> to return to EventManager.</html>";
    }

    private String orderId = "";

    private URI buildReturnUrl(HttpServletRequest request) {
        try {
            URI requestUri = URI.create(request.getRequestURL().toString());
            return new URI(requestUri.getScheme(),
                    requestUri.getUserInfo(),
                    requestUri.getHost(),
                    requestUri.getPort(),
                    "/orders/capture",
                    null, null);
        } catch (URISyntaxException e) {
            throw new RuntimeException(e);
        }
    }
}
