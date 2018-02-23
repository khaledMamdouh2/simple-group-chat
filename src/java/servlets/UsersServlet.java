/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlets;

import com.google.gson.Gson;
import entities.User;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author khaled
 */
@WebServlet(name = "UsersServlet", urlPatterns = {"/UsersServlet"})
public class UsersServlet extends HttpServlet {

    public static ArrayList<User> users = new ArrayList<>();
    private static ArrayList<User> activeUsers = new ArrayList<>();
   
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //return active users
        Gson gsonMessage = new Gson();
        String activeUsersObject = gsonMessage.toJson(activeUsers);
        PrintWriter out = response.getWriter();
        out.write(activeUsersObject);
        out.close();
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //login and logout
        if(request.getParameter("requestPage").equals("login")){//case of login
            String userName = request.getParameter("username");
            String password = request.getParameter("password");
            boolean found = false;
            for(User user : users){
                if(user.getUsername().equals(userName) && user.getPassword().equals(password)){
                    found = true;
                    activeUsers.add(user);
                    break;
                }
            }
            if(found){
                HttpSession session = request.getSession(true);
                session.setAttribute("username",userName);
                response.sendRedirect("home.jsp");
            }
            else{
                RequestDispatcher rd = request.getRequestDispatcher("index.html");
                rd.include(request, response);
                response.getOutputStream().print("invalid username or password");
                
            }
        }
        else{//case of logOut
            HttpSession session = request.getSession(false);
            String username = (String) session.getAttribute("username");
            for(User user : activeUsers){
                if(user.getUsername().equals(username)){
                    activeUsers.remove(user);
                    break;
                }
            }
            response.sendRedirect("index.html");
            session.invalidate();
        }
    }
    
}
