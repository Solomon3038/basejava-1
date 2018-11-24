package ru.javawebinar.basejava.web;

import ru.javawebinar.basejava.Config;
import ru.javawebinar.basejava.model.*;
import ru.javawebinar.basejava.storage.Storage;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.IOException;
import java.io.InputStream;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import static ru.javawebinar.basejava.util.DateUtil.NOW;
import static ru.javawebinar.basejava.util.ImageUtil.*;

@MultipartConfig
public class ResumeServlet extends HttpServlet {

    private Storage storage;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        storage = Config.get().getStorage();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws javax.servlet.ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String uuid = request.getParameter("uuid");
        String fullName = request.getParameter("fullName");
        Resume resume;

        if (uuid.equals("new")) {
            resume = new Resume(UUID.randomUUID().toString(), fullName);
        } else {
            resume = (Resume) storage.get(uuid);
            resume.setFullName(fullName);
        }

        Part filePart = request.getPart("photo");
        if (filePart != null) {
            if (filePart.getSize() <= 512 * 1024 && isImage(getFileName(filePart))) {
                InputStream inputStream = filePart.getInputStream();
                byte[] bytesFromInputStream = getBytesFromInputStream(inputStream);
                resume.setBytes(bytesFromInputStream);
                inputStream.close();
            }
        }

        for (ContactsType type : ContactsType.values()) {
            String value = request.getParameter(type.name());

            if (type.toString().equals("MAIL") && value.trim().length() == 0) {
                value = "empty@mail";
            }

            if (value != null && value.trim().length() != 0) {
                resume.addContact(type, value);
            } else {
                resume.getContacts().remove(type);
            }
        }
        for (SectionType typeSection : SectionType.values()) {
            switch (typeSection) {
                case PERSONAL:
                case OBJECTIVE:
                    String value1 = request.getParameter(typeSection.name());
                    if (value1 != null && value1.trim().length() != 0) {
                        resume.addCategory(typeSection, new StringCategory(value1));
                    } else {
                        resume.getSections().remove(typeSection);
                    }
                    break;
                case QUALIFICATIONS:
                case ACHIEVEMENT:
                    String[] value2 = request.getParameterValues(typeSection.name());
                    List<String> list = new ArrayList<>();
                    if (value2 != null) {
                        for (String v : value2) {
                            if (v != null && v.trim().length() != 0) {
                                list.add(v);
                            }
                        }
                    }
                    if (!list.isEmpty()) {
                        resume.addCategory(typeSection, new ListCategory(list));
                    } else {
                        resume.getSections().remove(typeSection);
                    }
                    break;
                case EDUCATION:
                case EXPERIENCE:
                    List<Organization> listOrganizations = new ArrayList<>();
                    int organizationCounter = Integer.valueOf(request.getParameter("organizationCounter"));
                    int positionCounter = Integer.valueOf(request.getParameter("positionCounter"));

                    for (int i = 0; i <= organizationCounter; i++) {
                        String organizationName = request.getParameter(typeSection.name() + "_organization" + i + "_1name");
                        if (organizationName != null) {
                            List<Organization.Position> listPositions = new ArrayList<>();
                            String organizationUrl = request.getParameter(typeSection.name() + "_organization" + i + "_2url");
                            for (int k = 0; k <= positionCounter; k++) {
                                String title = request.getParameter(typeSection.name() + "_organization" + i + "_position" + k + "_1title");
                                if (title != null) {
                                    String startDate = request.getParameter(typeSection.name() + "_organization" + i + "_position" + k + "_2startDate");
                                    String endDate = request.getParameter(typeSection.name() + "_organization" + i + "_position" + k + "_3endDate");
                                    String description = request.getParameter(typeSection.name() + "_organization" + i + "_position" + k + "_4description");

                                    if (endDate != null && endDate.trim().length() != 0) {
                                        listPositions.add(new Organization.Position(LocalDate.parse(startDate), LocalDate.parse(endDate), title, description));
                                    } else {
                                        listPositions.add(new Organization.Position(LocalDate.parse(startDate), NOW, title, description));
                                    }
                                }
                            }
                            listOrganizations.add(new Organization(new Link(organizationName, organizationUrl), listPositions));
                        }
                    }
                    if (!listOrganizations.isEmpty()) {
                        resume.addCategory(typeSection, new OrganizationsCategory(listOrganizations));
                    } else {
                        resume.getSections().remove(typeSection);
                    }
                    break;
                default:
                    break;
            }
        }

        if (uuid.equals("new")) {
            storage.save(resume);
        } else {
            storage.update(resume);
        }
        response.sendRedirect("resume");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws javax.servlet.ServletException, IOException {
        String uuid = request.getParameter("uuid");
        String action = request.getParameter("action");
        if (action == null) {
            request.setAttribute("resumes", storage.getAllSorted());
            request.getRequestDispatcher("/WEB-INF/jsp/list.jsp").forward(request, response);
            return;
        }
        Resume resume;
        switch (action) {
            case "delete":
                storage.delete(uuid);
                response.sendRedirect("resume");
                return;
            case "view":
            case "viewnoedit":
                resume = (Resume) storage.get(uuid);
                getImage(request, resume);
                break;
            case "edit":
            case "noedit":
                resume = (Resume) storage.get(uuid);
                break;
            case "new":
                resume = new Resume();
                break;
            default:
                throw new IllegalArgumentException("Action " + action + " is illegal");
        }
        request.setAttribute("resume", resume);
        request.getRequestDispatcher(
                ("noedit".equals(action) ? "/WEB-INF/jsp/noedit.jsp" : "view".equals(action) ? "/WEB-INF/jsp/view.jsp" : "edit".equals(action) ? "/WEB-INF/jsp/edit.jsp" :
                        "viewnoedit".equals(action) ? "/WEB-INF/jsp/viewnoedit.jsp" : "/WEB-INF/jsp/new.jsp")
        ).forward(request, response);
    }
}