<%@ page import="ru.javawebinar.basejava.model.ContactsType" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"
          integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
    <link rel="shortcut icon" href="img/favicon2.ico" type="image/x-icon">
    <link rel="stylesheet" type="text/css" href="css/styles.css">
    <title>Список всех резюме</title>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-light sticky-top rounded box-shadow-grey" style="background: white">
    <div class="container">
    <a href="https://topjava.ru/" class="navbar-brand"><img src="img/TJ.svg" alt="logo"></a>
    <button class="navbar-toggler my-auto" type="button" data-toggle="collapse"
            data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false"
            aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse my-auto" id="navbarSupportedContent">
        <ul class="navbar-nav column-in-center">
            <li class="nav-item">
                <h5 class="my-auto nav-link text-secondary">Web-приложение &#171База данных резюме&#187 курса Basejava</h5>
            </li>
        </ul>
        <a href="resume?action=new"><h6 class="my-1" style="white-space:nowrap;color: #234463;"><b>ДОБАВИТЬ РЕЗЮМЕ</b></h6></a>
    </div>
    </div>
</nav>

    <div class="container mt-5">

        <h1 class="text-center" style="color: #1CA3E6;"><b>Список резюме</b></h1>

        <div class="row mt-5">
            <c:forEach items="${resumes}" var="resume">
                <jsp:useBean id="resume" type="ru.javawebinar.basejava.model.Resume"/>
                <c:choose>
                    <c:when test="${resume.fullName=='Григорий Кислин' || resume.fullName=='Ирина Грицюк'}">

                        <div class="col-sm-12 col-md-6 col-lg-6 col-xl-4 my-3 column-in-center">
                            <div class="card box-shadow-lines">
                                <div class="card-body text-center">
                                    <a href="resume?uuid=${resume.uuid}&action=viewnoedit" class="text-dark"><h4
                                            class="card-title">${resume.fullName}</h4></a>
                                    <p class="card-text"
                                       style="color: #1CA3E6;"><%=ContactsType.MAIL.toHtml(resume.getContacts(ContactsType.MAIL))%>
                                    </p>
                                    <a href="resume?uuid=${resume.uuid}&action=viewnoedit" title="открыть">
                                        <button type="button" class="btn box-shadow-grey round"><i
                                                class="fa fa-address-book-o mx-2"></i></button>
                                    </a>
                                    <a href="resume?uuid=${resume.uuid}&action=noedit" title="редактировать">
                                        <button type="button" class="btn box-shadow-grey round"><i
                                                class="fa fa-pencil mx-2"></i></button>
                                    </a>
                                    <a href="#" title="удалить">
                                        <button type="button" class="btn box-shadow-grey round"><i
                                                class="fa fa-close mx-2"></i></button>
                                    </a>
                                </div>
                            </div>
                        </div>

                    </c:when>
                    <c:otherwise>

                        <div class="col-sm-12 col-md-6 col-lg-6 col-xl-4 my-3 column-in-center">
                            <div class="card box-shadow-lines">
                                <div class="card-body text-center">
                                    <a href="resume?uuid=${resume.uuid}&action=view" class="text-dark"><h4
                                            class="card-title">${resume.fullName}</h4></a>
                                    <p class="card-text"
                                       style="color: #1CA3E6;"><%=ContactsType.MAIL.toHtml(resume.getContacts(ContactsType.MAIL))%>
                                    </p>
                                    <a href="resume?uuid=${resume.uuid}&action=view" title="открыть">
                                        <button type="button" class="btn box-shadow-grey round"><i
                                                class="fa fa-address-book-o mx-2"></i></button>
                                    </a>
                                    <a href="resume?uuid=${resume.uuid}&action=edit" title="редактировать">
                                        <button type="button" class="btn box-shadow-grey round"><i
                                                class="fa fa-pencil mx-2"></i></button>
                                    </a>
                                    <a href="resume?uuid=${resume.uuid}&action=delete" title="удалить">
                                        <button type="button" class="btn box-shadow-grey round"><i
                                                class="fa fa-close mx-2"></i></button>
                                    </a>
                                </div>
                            </div>
                        </div>

                    </c:otherwise>
                </c:choose>
            </c:forEach>
        </div>
    </div>

    <div class="my-5"></div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js" type="text/javascript"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js"
            integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy"
            crossorigin="anonymous"></script>
</body>
</html>