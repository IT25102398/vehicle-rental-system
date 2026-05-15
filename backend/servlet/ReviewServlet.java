package com.vehiclerental.servlet;

import com.vehiclerental.model.Review;
import com.vehiclerental.service.ReviewService;
import com.vehiclerental.service.User;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

public class ReviewServlet extends HttpServlet {
    private File getDatabaseFile(String fileName) {
        String appRoot = getServletContext().getRealPath("/");
        if (appRoot == null) {
            return new File("database", fileName);
        }
        File frontendDir = new File(appRoot);
        File projectDir = frontendDir.getParentFile();
        return new File(new File(projectDir, "database"), fileName);
    }

    private User getLoggedInUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session == null ? null : (User) session.getAttribute("loggedInUser");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = getLoggedInUser(request);
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        File reviewFile = getDatabaseFile("reviews.txt");
        List<Review> reviews = ReviewService.getAllReviews(reviewFile);
        String path = request.getServletPath();

        if ("/submitReview".equals(path)) {
            reviews.add(new Review(
                    ReviewService.generateReviewId(reviews),
                    user.getUserId(),
                    request.getParameter("vehicleId"),
                    Integer.parseInt(request.getParameter("rating")),
                    request.getParameter("comment"),
                    LocalDate.now().toString()
            ));
        } else if ("/updateReview".equals(path)) {
            String reviewId = request.getParameter("reviewId");
            for (Review review : reviews) {
                if (review.getReviewId().equals(reviewId) && review.getUserId().equals(user.getUserId())) {
                    review.setRating(Integer.parseInt(request.getParameter("rating")));
                    review.setComment(request.getParameter("comment"));
                    review.setDate(LocalDate.now().toString());
                    break;
                }
            }
        } else if ("/deleteReview".equals(path)) {
            String reviewId = request.getParameter("reviewId");
            reviews.removeIf(review -> review.getReviewId().equals(reviewId) &&
                    (review.getUserId().equals(user.getUserId()) || "admin".equals(user.getRole())));
        }

        ReviewService.saveAllReviews(reviews, reviewFile);
        response.sendRedirect("reviews.jsp");
    }
}
