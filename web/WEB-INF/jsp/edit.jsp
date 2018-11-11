<%@ page import="ru.javawebinar.basejava.model.ContactsType" %>
<%@ page import="ru.javawebinar.basejava.model.SectionType" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.io.*,java.util.Locale" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html" charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"
          integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
    <link rel="shortcut icon" href="img/favicon2.ico" type="image/x-icon">
    <link rel="stylesheet" href="css/styles.css">
    <script src="js/main.js" type="text/javascript" charset="UTF-8"></script>
    <jsp:useBean id="resume" type="ru.javawebinar.basejava.model.Resume" scope="request"/>
    <title>Редактирование ${resume.fullName}</title>
</head>
<body>

<jsp:include page="fragments/header.jsp"/>

<div class="container mt-5 box-shadow-blue">
    <div class="mx-2">
        <form method="post" action="resume" enctype="multipart/form-data">
            <input type="hidden" name="uuid" value="${resume.uuid}">

            <p class="nav-href-indent-edit" id="name"></p>
            <div class="row">
                <div class="col">
                    <div class="form-group">
                        <label class="mx-2">Полное имя:</label>
                        <input type="text" class="form-control" name="fullName" value="${resume.fullName}" required>
                    </div>
                </div>
            </div>


            <h4 class="text-center text-secondary nav-href-indent-edit" id="contacts"><b>Контакты</b></h4>
            <div class="form-group">
                <div class="row">
                    <c:forEach var="type" items="<%=ContactsType.values()%>">

                        <div class="col-sm-12 col-md-6 col-lg-6 col-xl-4 my-3 column-in-center">
                            <label class="mx-2 my-1">${type.title}</label>
                            <input type="text" class="form-control" name="${type.name()}"
                                   value="${resume.getContacts(type)}">
                        </div>

                    </c:forEach>
                </div>
            </div>

            <c:forEach var="typeSection" items="<%=SectionType.values()%>">
                <c:if test="${typeSection.name()=='OBJECTIVE'||typeSection.name()=='PERSONAL'}">
                    <h4 class="text-center text-secondary nav-href-indent-edit" id="${typeSection.name()}">
                        <b>${typeSection.title}</b>
                    </h4>
                    <div class="input-group">
                    <textarea type="text" class="form-control my-3"
                              name="${typeSection.name()}">${resume.getSections(typeSection)}</textarea>
                    </div>
                </c:if>
                <c:if test="${typeSection.name()=='ACHIEVEMENT'||typeSection.name()=='QUALIFICATIONS'}">
                    <h4 class="text-center text-secondary nav-href-indent-edit" id="${typeSection.name()}">
                        <b>${typeSection.title}</b>
                    </h4>

                    <button type="button"
                            class="btn mt-3 my-3 btn-outline-primary btn-lg btn-block" style="border-radius: 10px;">
                        <a href="javascript:addSinglePosition('${typeSection.name()}+1','<div class=form-group><div class=input-group><textarea type=text class=form-control my-1 name=${typeSection.name()}></textarea></div></div>')">
                            Добавить позицию</a>
                    </button>

                    <div id="${typeSection.name()}+1"></div>

                    <c:forEach var="section" items="${resume.getSections(typeSection).getItems()}">
                        <div class="form-group">
                            <div class="input-group">
                        <textarea type="text" class="form-control my-1"
                                  name="${typeSection.name()}">${section}</textarea>
                            </div>
                        </div>
                    </c:forEach>
                </c:if>

                <c:if test="${typeSection.name()=='EXPERIENCE'||typeSection.name()=='EDUCATION'}">
                    <c:choose>
                        <c:when test="${typeSection.title=='Опыт работы'}">
                            <c:set var="nameCompany" value="компании" scope="page"/>
                            <c:set var="nameCompany1" value="компанию" scope="page"/>
                        </c:when>
                        <c:otherwise>
                            <c:set var="nameCompany" value="учереждения" scope="page"/>
                            <c:set var="nameCompany1" value="учереждение" scope="page"/>
                        </c:otherwise>
                    </c:choose>

                    <h4 class="text-center text-secondary nav-href-indent-edit" id="${typeSection.name()}">
                        <b>${typeSection.title}</b>
                    </h4>

                    <button type="button"
                            class="btn btn-block mt-3 my-3 btn-outline-primary btn-lg"
                            style="border-radius: 10px;">
                        <a id="myLink" href="#"
                           onclick="javascript:addOrganization('${typeSection.name()}+1', 'fieldset', '${typeSection.name()}','${nameCompany}');return false;">
                            Добавить ${nameCompany1}</a>
                    </button>

                    <div id="${typeSection.name()}+1"></div>

                    <c:set var="count" value="0" scope="page"/>
                    <c:forEach var="organization"
                               items="${resume.getSections(typeSection).getOrganizations()}">

                        <fieldset id="${typeSection.name()}_organization${count}">

                            <div class="form-group box-shadow-blue mt-2">
                                <div class="card mt-2">
                                    <div class="card-body">

                                        <div class="form-group">
                                            <a id="myLink2" href="#"
                                               onclick="javascript:deleteElement('${typeSection.name()}_organization${count}');return false;">
                                                <i class="fa fa-times" aria-hidden="true"
                                                   style="color: #D780F1;"></i>
                                                <h7 class="mx-2">Удалить организацию</h7>
                                            </a>

                                            <div class="row">
                                                <div class="col">
                                                    <label>Название ${nameCompany}:</label>
                                                    <input type="text" class="form-control"
                                                           name="${typeSection.name()}_organization${count}_1name"
                                                           value="${organization.getHomePage().getName()}" required>
                                                </div>
                                                <div class="col">
                                                    <label>Сайт ${nameCompany}:</label>
                                                    <input type="text" class="form-control"
                                                           name="${typeSection.name()}_organization${count}_2url"
                                                           value="${organization.getHomePage().getUrl()}">
                                                </div>
                                            </div>
                                        </div>

                                        <div class="form-group">
                                            <a id="myLink1" href="#"
                                               onclick="javascript:addPosition('${typeSection.name()}_organization${count}', 'fieldset', '${typeSection.name()}_organization${count}');return false;"><i
                                                    class="fa fa-plus" aria-hidden="true"
                                                    style="color: #3D6BE9;"></i>
                                                <h7 class="mx-2">Добавить позицию</h7>
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <c:set var="countPosition" value="0" scope="page"/>
                            <c:forEach var="position" items="${organization.getPositions()}">

                                <fieldset
                                        id="${typeSection.name()}_organization${count}_position${countPosition}">

                                    <div class="card my-2">
                                        <div class="card-header">
                                            <div class="form-group">
                                                <a id="myLink3" href="#"
                                                   onclick="javascript:deleteElement('${typeSection.name()}_organization${count}_position${countPosition}');return false;">
                                                    <i class="fa fa-times" aria-hidden="true"
                                                       style="color: #D780F1;"></i>
                                                    <h7 class="mx-2">Удалить позицию</h7>
                                                </a>

                                                <div class="row">
                                                    <div class="col">
                                                        <label>Дата начала:</label>
                                                        <input type="date" class="form-control"
                                                               name="${typeSection.name()}_organization${count}_position${countPosition}_2startDate"
                                                               value="${position.getStartDate()}"
                                                               required>
                                                    </div>
                                                    <div class="col">
                                                        <label>Дата окончания:</label>
                                                        <input type="date" class="form-control"
                                                               name="${typeSection.name()}_organization${count}_position${countPosition}_3endDate"
                                                               value="${position.getEndDate()}">
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label>Должность:</label>
                                                <input type="text" class="form-control"
                                                       name="${typeSection.name()}_organization${count}_position${countPosition}_1title"
                                                       value="${position.getTitle()}" required>
                                            </div>
                                            <div class="form-group">
                                                <label>Описание:</label>
                                                <div class="input-group">
                                                        <textarea type="text"
                                                                  class="form-control my-1"
                                                                  name="${typeSection.name()}_organization${count}_position${countPosition}_4description">${position.getDescription()}
                                                        </textarea>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </fieldset>

                                <c:set var="countPosition" value="${countPosition+1}" scope="page"/>
                            </c:forEach>

                        </fieldset>

                        <c:set var="count" value="${count+1}" scope="page"/>
                    </c:forEach>

                    <c:if test="${not empty count}">
                        <input type="hidden" id="organizationCounter" name="organizationCounter"
                               value="${count}">
                    </c:if>
                    <c:if test="${empty count}">
                        <input type="hidden" id="organizationCounter" name="organizationCounter" value="0">
                    </c:if>
                    <c:if test="${not empty countPosition}">
                        <input type="hidden" id="positionCounter" name="positionCounter"
                               value="${countPosition}">
                    </c:if>
                    <c:if test="${empty countPosition}">
                        <input type="hidden" id="positionCounter" name="positionCounter" value="0">
                    </c:if>

                </c:if>
            </c:forEach>

            <div class="mt-4 mx-auto text-center">
                <h6 class="text-secondary">Максимальный размер изображения: 500kb</h6>
                <h6 class="text-secondary">формат файла: GIF, JPEG, JPG, PNG</h6>
                <h5><input type="file" class="mt-3" name="file"></h5>
            </div>

            <div class="text-center">
                <button type="submit" class="btn my-4 mx-2 box-shadow-grey round" name="save" value="1"><h5
                        class="mx-2 my-1">
                    Сохранить</h5></button>
                <a href="resume">
                    <button type="button" class="btn my-4 mx-2 box-shadow-grey round"
                            name="CancelEdit" value="1"><h5 class="mx-2 my-1">Отменить</h5></button>
                </a>
            </div>
        </form>
    </div>
</div>

<div class="my-5"></div>

<jsp:include page="fragments/footer.jsp"/>

</body>
</html>