package ru.javawebinar.basejava.storage;

public class ObjectStreamPathStorageTest extends AbstractStorageTest{

    public ObjectStreamPathStorageTest() {
        super(new ObjectStreamStorage(STORAGE_DIR.getAbsoluteFile()));
    }
}