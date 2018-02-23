<%-- 
    Document   : home
    Created on : Feb 23, 2018, 2:27:11 PM
    Author     : khaled
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>group chat</title>
    </head>
    <body>
        <h1 align="center" id="nameField">${sessionScope['username']}</h1>
        <form style="float:right;" action= "UsersServlet" method="post">
            <input type="submit" value="logout">
            <input type="hidden" value="home" name="requestPage">
        </form>
        <h3 align="right">online users</h3>
        <table id="usersTable" style="float:right;"></table>
        your message:<input type="text" id="messageField" /><br>
        <button onclick="sendMessage()">Send</button>
        <h3>Messages</h3>
        <table id="msgsTable">
            
        </table>
        <script src="jquery.min.js"></script>
        <script type="text/javascript" >
            function sendMessage(){
                var username = document.getElementById("nameField").innerHTML;
                var message = document.getElementById("messageField").value;
                $.post("ChatServlet" , {
                    name: username,
                    message: message});
            }
            //getting messages
            setInterval(function(){
                $.get("ChatServlet" ,function (responseTxt, statusTxt, xhr){
                    if (statusTxt == "success"){
                        document.getElementById("msgsTable").innerHTML="<th>user name</th><th>message</th>";
                        var messagesObject = JSON.parse(responseTxt);
                        for(i=0; i<messagesObject.length; i++){
                            var username = messagesObject[i].username;
                            var message = messagesObject[i].message;
                            var tr = document.createElement("tr");
                            var td1 = document.createElement("td");
                            var td2 = document.createElement("td");
                            td1.innerHTML = username;
                            td2.innerHTML = message;
                            tr.appendChild(td1);
                            tr.appendChild(td2);
                            document.getElementById("msgsTable").appendChild(tr);
                        }
                    }
                })
            } , 4000);
            //getting online users
            setInterval(function(){
                $.get("UsersServlet" ,function (responseTxt, statusTxt, xhr){
                    if (statusTxt == "success"){
                        document.getElementById("usersTable").innerHTML="<th>user name</th>";
                        var usersObject = JSON.parse(responseTxt);
                        for(i=0; i<usersObject.length; i++){
                            var username = usersObject[i].username;
                            var tr = document.createElement("tr");
                            var td1 = document.createElement("td");
                            td1.innerHTML = username;
                            tr.appendChild(td1);
                            document.getElementById("usersTable").appendChild(tr);
                        }
                    }
                })
            } , 4000);
        </script>
        <script src="jquery.min.js"></script>
    </body>
</html>
