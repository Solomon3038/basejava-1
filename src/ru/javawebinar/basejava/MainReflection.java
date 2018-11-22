package ru.javawebinar.basejava;

import ru.javawebinar.basejava.model.Resume;

import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

public class MainReflection {

    public static void main(String[] args) throws IllegalAccessException, NoSuchMethodException, InvocationTargetException {

        Resume resume = new Resume("name");
        Field field = resume.getClass().getDeclaredFields()[0];
        Method method = Resume.class.getMethod("toString");

        System.out.println(method.invoke(resume));

        field.setAccessible(true);

        System.out.println(field.getName());
        System.out.println(field.get(resume));

        field.set(resume, "new_name");

        System.out.println(resume);
        System.out.println(method.getReturnType());
    }
}
