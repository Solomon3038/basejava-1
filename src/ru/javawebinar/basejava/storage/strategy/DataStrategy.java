package ru.javawebinar.basejava.storage.strategy;

import ru.javawebinar.basejava.model.*;

import java.io.*;
import java.time.Month;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class DataStrategy implements SerializationStrategy {

    @Override
    public void doWrite(Resume resume, OutputStream os) throws IOException {
        try (DataOutputStream dos = new DataOutputStream(os)) {
            dos.writeUTF(resume.getUuid());
            dos.writeUTF(resume.getFullName());
            Map<ContactsType, String> contacts = resume.getContacts();
            dos.writeInt(contacts.size());
            for (Map.Entry<ContactsType, String> entry : contacts.entrySet()) {
                dos.writeUTF(entry.getKey().name());
                dos.writeUTF(entry.getValue());
            }
            Map<SectionType, Category> categories = resume.getSections();
            dos.writeInt(categories.size());
            for (Map.Entry<SectionType, Category> entry : categories.entrySet()) {
                dos.writeUTF(entry.getKey().name());
                switch (entry.getKey()) {
                    case PERSONAL:
                    case OBJECTIVE:
                        dos.writeUTF(((StringCategory) entry.getValue()).getContent());
                        break;
                    case ACHIEVEMENT:
                    case QUALIFICATIONS:
                        List<String> listA = ((ListCategory) entry.getValue()).getItems();
                        dos.writeInt(listA.size());
                        for (String listEch : listA) {
                            dos.writeUTF(listEch);
                        }
                        break;
                    case EDUCATION:
                    case EXPERIENCE:
                        List<Organization> listO = ((OrganizationsCategory) entry.getValue()).getOrganizations();
                        dos.writeInt(listO.size());
                        writeOrganizations(dos, listO);
                        break;
                    default:
                        break;
                }
            }
        }
    }

    @Override
    public Resume doRead(InputStream is) throws IOException {
        try (DataInputStream dis = new DataInputStream(is)) {
            String uuid = dis.readUTF();
            String fullName = dis.readUTF();
            Resume resume = new Resume(uuid, fullName);
            int sizeContacts = dis.readInt();
            for (int i = 0; i < sizeContacts; i++) {
                resume.addContact(ContactsType.valueOf(dis.readUTF()), dis.readUTF());
            }
            int sizeCategories = dis.readInt();
            for (int i = 0; i < sizeCategories; i++) {
                SectionType sectionType = SectionType.valueOf(dis.readUTF());
                switch (sectionType) {
                    case PERSONAL:
                    case OBJECTIVE:
                        resume.addCategory(sectionType, new StringCategory(dis.readUTF()));
                        break;
                    case ACHIEVEMENT:
                    case QUALIFICATIONS:
                        List<String> listA = new ArrayList<>();
                        int sizeA = dis.readInt();
                        for (int a = 0; a < sizeA; a++) {
                            listA.add(dis.readUTF());
                        }
                        resume.addCategory(sectionType, new ListCategory(listA));
                        break;
                    case EDUCATION:
                    case EXPERIENCE:
                        readOrganizations(dis, sectionType, resume);
                        break;
                    default:
                        break;
                }
            }
            return resume;
        }
    }

    private void writeOrganizations(DataOutputStream dos, List<Organization> listO) throws IOException {
        for (Organization o : listO) {
            dos.writeUTF(o.getHomePage().getName());
            if (o.getHomePage().getUrl() != null) {
                dos.writeUTF(o.getHomePage().getUrl());
            } else {
                dos.writeUTF("");
            }
            List<Organization.Position> listOP = o.getPositions();
            dos.writeInt(listOP.size());
            for (Organization.Position p : listOP) {
                dos.writeInt(p.getStartDate().getYear());
                dos.writeUTF(p.getStartDate().getMonth().name());
                dos.writeInt(p.getEndDate().getYear());
                dos.writeUTF(p.getEndDate().getMonth().name());
                dos.writeUTF(p.getTitle());
                if (p.getDescription() != null) {
                    dos.writeUTF(p.getDescription());
                } else {
                    dos.writeUTF("");
                }
            }
        }
    }

    private void readOrganizations(DataInputStream dis, SectionType sectionType, Resume resume) throws IOException {
        List<Organization> listO = new ArrayList<>();
        int sizeO = dis.readInt();
        for (int o = 0; o < sizeO; o++) {
            String name = dis.readUTF();
            String url = dis.readUTF();
            if (url.equals("")) {
                url = null;
            }
            List<Organization.Position> listOP = new ArrayList<>();
            listO.add(new Organization(new Link(name, url), listOP));
            int sizeOP = dis.readInt();
            for (int op = 0; op < sizeOP; op++) {
                int startDate = dis.readInt();
                Month monthB = Month.valueOf(dis.readUTF());
                int endDate = dis.readInt();
                Month monthE = Month.valueOf(dis.readUTF());
                String title = dis.readUTF();
                String description = dis.readUTF();
                if (description.equals("")) {
                    description = null;
                }
                listOP.add(new Organization.Position(startDate, monthB, endDate, monthE,
                        title, description));
            }
        }
        resume.addCategory(sectionType, new OrganizationsCategory(listO));
    }
}