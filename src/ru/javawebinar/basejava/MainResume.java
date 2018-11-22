package ru.javawebinar.basejava;

import ru.javawebinar.basejava.model.*;

import java.time.LocalDate;
import java.time.Month;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class MainResume {

    public static void main(String[] args) {

        Resume resume = new Resume("uuid1", "Ирина Грыцюк");
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("LL/yyyy");
        Organization expOrg1 = new Organization(
                new Link("Работа 1", "http://javaops.ru/reg/basejava/1"),
                new ArrayList<>(Arrays.asList((new Organization.Position(LocalDate.of(2006, Month.APRIL, 10),
                                LocalDate.of(2009, Month.SEPTEMBER, 05), "position1", "duties1")),
                        (new Organization.Position(LocalDate.of(2007, Month.APRIL, 10),
                                LocalDate.of(2008, Month.SEPTEMBER, 05), "position1", "duties1")))));
        Organization expOrg2 = new Organization(
                new Link("Работа 2", "http://12345"),
                new ArrayList<>(Arrays.asList(new Organization.Position(LocalDate.of(2006, Month.APRIL, 10),
                        LocalDate.of(2009, Month.SEPTEMBER, 05), "position1", "duties1"))));
        List<Organization> listExp = new ArrayList<>(Arrays.asList(expOrg1, expOrg2));
        Organization eduOrg1 = new Organization(
                new Link("Учеба 1", "http://javaops.ru/1"),
                new ArrayList<>(Arrays.asList(new Organization.Position(LocalDate.of(2003, Month.APRIL, 10),
                        LocalDate.of(2008, Month.SEPTEMBER, 05), "студент", null))));
        Organization eduOrg2 = new Organization(
                new Link("Учеба 2", "http://javaops.ru/2"),
                new ArrayList<>(Arrays.asList(new Organization.Position(LocalDate.of(2016, Month.APRIL, 10),
                        LocalDate.of(2018, Month.SEPTEMBER, 05), "студент заочно", null))));
        List<Organization> listEdu = new ArrayList<>(Arrays.asList(eduOrg1, eduOrg2));

        resume.getContacts().put(ContactsType.PHONE, "+3801235467");
        resume.getContacts().put(ContactsType.SKYPE, "gagarina6794");
        resume.getSections().put(SectionType.OBJECTIVE, new StringCategory("Junior Java Developer"));
        resume.getSections().put(SectionType.PERSONAL, new StringCategory("Аналитический склад ума"));
        resume.getSections().put(SectionType.ACHIEVEMENT, new ListCategory(new ArrayList<>(Arrays.asList("Пока только бухгалтерские", "и спортивные)"))));
        resume.getSections().put(SectionType.QUALIFICATIONS, new ListCategory(new ArrayList<>(Arrays.asList("Java junior", "Bookkeeper"))));
        resume.getSections().put(SectionType.EXPERIENCE, new OrganizationsCategory(listExp));
        resume.getSections().put(SectionType.EDUCATION, new OrganizationsCategory(listEdu));

        System.out.println(resume.getFullName());
        System.out.println("-------------------------");
        resume.getContacts().forEach((k, v) -> System.out.println("* " + k.getTitle() + " " + v));
        System.out.println("________________________________");
        System.out.println("* " + SectionType.OBJECTIVE.getTitle() + "\n" + ((StringCategory)resume.getSections().get(SectionType.OBJECTIVE)).getContent());
        System.out.println("________________________________");
        System.out.println("* " + SectionType.PERSONAL.getTitle() + "\n" + ((StringCategory)resume.getSections().get(SectionType.PERSONAL)).getContent());
        System.out.println("________________________________");

        System.out.println(SectionType.ACHIEVEMENT.getTitle());
        ((ListCategory) resume.getSections().get(SectionType.ACHIEVEMENT))
                .getItems().forEach(x -> System.out.println("- " + x));
        System.out.println("________________________________");
        System.out.println(SectionType.QUALIFICATIONS.getTitle());
        ((ListCategory) resume.getSections().get(SectionType.QUALIFICATIONS))
                .getItems().forEach(x -> System.out.println("- " + x));
        System.out.println("________________________________");
        System.out.println(SectionType.EXPERIENCE.getTitle());
        ((OrganizationsCategory) resume.getSections().get(SectionType.EXPERIENCE)).getOrganizations().forEach(
                x -> {
                    System.out.println(x.getHomePage().getName() + " " + x.getHomePage().getUrl());
                    x.getPositions().forEach(y ->
                            System.out.println(y.getStartDate().format(formatter) + " " + y.getEndDate().format(formatter) + " " +
                                    y.getTitle() + " " + y.getDescription()));
                }
        );
        System.out.println("________________________________");
        System.out.println(SectionType.EDUCATION.getTitle());
        ((OrganizationsCategory) resume.getSections().get(SectionType.EDUCATION)).getOrganizations().forEach(
                x -> {
                    System.out.println(x.getHomePage().getName() + " " + x.getHomePage().getUrl());
                    x.getPositions().forEach(y ->
                            System.out.println(y.getStartDate().format(formatter) + " " + y.getEndDate().format(formatter) + " " +
                                    y.getTitle())); });
    }
}