<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"
          integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
    <link rel="shortcut icon" href="img/favicon2.ico" type="image/x-icon">
    <link rel="stylesheet" type="text/css" href="css/styles.css">
    <jsp:useBean id="resume" type="ru.javawebinar.basejava.model.Resume" scope="request"/>
    <title>Резюме ${resume.fullName}</title>
</head>
<body>

<jsp:include page="fragments/header.jsp"/>

<p id="name" class="nav-href-indent"></p>
<div class="container mt-5 box-shadow-blue">
    <div class="mx-2">
        <h1></h1>

        <form action="resume" method="POST">
            <input type="hidden" name="uuid" value="${resume.uuid}">

            <div class="row">
                <div class="col-8">
                    <h1 class="text-info" align="center"><p
                            style="font-weight: bold;color:#1CA3E6;">${resume.fullName}</p></h1>

                    <c:if test="${not empty resume.getSections()}">
                        <p id="contacts" class="nav-href-indent"></p>
                    </c:if>

                    <c:forEach var="contactEntry" items="${resume.contacts}">
                    <jsp:useBean id="contactEntry"
                                 type="java.util.Map.Entry<ru.javawebinar.basejava.model.ContactsType, java.lang.String>"/>
                    <c:choose>
                    <c:when test="${contactEntry.key=='PHONE'}">
                    <h5><i class="fa fa-phone mx-3 my-1 text-primary" aria-hidden="true"></i>
                        </c:when>
                        <c:when test="${contactEntry.key=='MOBILE'}">
                        <h5><font size="6"><i class="fa fa-mobile mx-3 my-1 text-primary"
                                              aria-hidden="true"></i></font>
                            </c:when>
                            <c:when test="${contactEntry.key=='HOME_PHONE'}">
                            <h5><i class="fa fa-phone-square mx-3 my-1 text-primary" aria-hidden="true"></i>
                                </c:when>
                                <c:when test="${contactEntry.key=='SKYPE'}">
                                <h5><i class="fa fa-skype mx-3 text-info" aria-hidden="true"></i>
                                    </c:when>
                                    <c:when test="${contactEntry.key=='MAIL'}">
                                    <h5><i class="fa fa-envelope mx-3 my-1 text-warning" aria-hidden="true"></i>
                                        </c:when>
                                        <c:when test="${contactEntry.key=='LINKEDIN'}">
                                        <h5><i class="fa fa-linkedin-square mx-3 my-1 text-primary"
                                               aria-hidden="true"></i>
                                            </c:when>
                                            <c:when test="${contactEntry.key=='GITHUB'}">
                                            <h5><i class="fa fa-github-alt mx-3 my-1" aria-hidden="true"></i>
                                                </c:when>
                                                <c:when test="${contactEntry.key=='STACKOVERFLOW'}">
                                                <h5><i class="fa fa-stack-overflow mx-3 my-1 text-danger"
                                                       aria-hidden="true"></i>
                                                    </c:when>
                                                    <c:when test="${contactEntry.key=='HOME_PAGE'}">
                                                    <h5><i class="fa fa-link mx-3 my-1 text-primary"
                                                           aria-hidden="true"></i>
                                                        </c:when>
                                                        </c:choose>
                                                        <%=contactEntry.getKey().toHtml(contactEntry.getValue())%>
                                                    </h5>
                                                    </c:forEach>
                </div>
                <div class="col-4">
                    <img class="card-img-top rounded mx-auto ml-auto" src="${resume.imagePath}"
                         style="width:95%;height:auto;">
                </div>
            </div>
            <c:forEach var="sectionEntry" items="${resume.sections}">
                <jsp:useBean id="sectionEntry"
                             type="java.util.Map.Entry<ru.javawebinar.basejava.model.SectionType, ru.javawebinar.basejava.model.Category>"/>
                <p id="<%=sectionEntry.getKey()%>" class="nav-href-indent"></p>
                <h2 class="no-background my-3 text-info"><span
                        style="color:#1CA3E6;"><%=sectionEntry.getKey().getTitle()%></span>
                </h2>
                <c:set var="key" scope="session" value="<%=sectionEntry.getKey()%>"/>
                <c:set var="value" scope="session" value="<%=sectionEntry.getValue()%>"/>
                <c:choose>
                    <c:when test="${key=='PERSONAL'||key=='OBJECTIVE'}">
                        <h5 class="text-center">${value.getContent()}</h5>
                    </c:when>
                    <c:when test="${key=='ACHIEVEMENT'||key=='QUALIFICATIONS'}">
                        <ul>
                            <c:forEach var="listItems" items="${value.getItems()}">
                                <li><h5>${listItems}</h5></li>
                            </c:forEach>
                        </ul>
                    </c:when>
                    <c:when test="${key=='EXPERIENCE'||key=='EDUCATION'}">
                        <c:forEach var="listExp" items="${value.getOrganizations()}">
                            <c:forEach var="listPos" items="${listExp.getPositions()}">
                                <table class="table borderless">
                                    <tbody class="text-xs-left">
                                    <tr style="background-color: #e8f4ff;">

                                        <c:if test="${not empty listExp.getHomePage().getUrl()}">
                                            <td class="left-round"><h5><b>Компания:</b></h5></td>
                                            <td class="right-round"><h5><a href="${listExp.getHomePage().getUrl()}">
                                                    ${listExp.getHomePage().getName()}</a></h5></td>
                                        </c:if>
                                        <c:if test="${empty listExp.getHomePage().getUrl()}">
                                            <td class="left-round"><h5><b>Компания:</b></h5></td>
                                            <td class="right-round"><h5>${listExp.getHomePage().getName()}</h5></td>
                                        </c:if>
                                    </tr>
                                    <tr>
                                        <td><h5><b>Период:</b></h5></td>
                                        <td><h5>${listPos.getStartDate().format(DateTimeFormatter.ofPattern("LL/yyyy"))}
                                            &mdash;
                                            <c:if test="${listPos.getEndDate()!=LocalDate.of(3000, 1, 1)}">
                                                ${listPos.getEndDate().format(DateTimeFormatter.ofPattern("LL/yyyy"))}
                                            </c:if>
                                            <c:if test="${listPos.getEndDate()==LocalDate.of(3000, 1, 1)}">
                                                Сегодня
                                            </c:if>
                                        </h5></td>
                                    </tr>
                                    <tr>
                                        <td><h5><b>Должность:</b></h5></td>
                                        <td style="width: 100%"><h5>${listPos.getTitle()}</h5></td>
                                    </tr>
                                    <tr>
                                        <td><h5><b>Описание:</b></h5></td>
                                        <td><h5>${listPos.getDescription()}</h5></td>
                                    </tr>
                                    </tbody>
                                </table>
                            </c:forEach>
                        </c:forEach>
                    </c:when>
                </c:choose>
            </c:forEach>
            <div class="text-center">
                <a href="resume?uuid=${resume.uuid}&action=noedit">
                    <button type="button"
                            class="btn my-4 box-shadow-grey round"><h5
                            class="my-1 mx-2">Редактировать</h5></button>
                </a>
            </div>
        </form>
    </div>
</div>

<div class="my-5"></div>

<jsp:include page="fragments/footer.jsp"/>

</body>
</html>
<%--<jsp:include page="fragments/header.jsp"/>--%>
<%--<a href="resume?uuid=${resume.uuid}&action=noedit" class="btn btn-add">Редактировать</a>--%>
<%--<jsp:include page="fragments/footer.jsp"/>--%>