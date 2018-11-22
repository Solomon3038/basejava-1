package ru.javawebinar.basejava.storage;

import ru.javawebinar.basejava.model.Resume;

import java.util.Arrays;
import java.util.Comparator;

public class SortedArrayStorage extends AbstractArrayStorage {

    private static final Comparator<Resume> RESUME_COMPARATOR = Comparator.comparing(Resume::getUuid);

    @Override
    protected Integer getIndex(String uuid) {
        return Arrays.binarySearch(storage, 0, size, new Resume(uuid, "fullName"), RESUME_COMPARATOR);
    }

    @Override
    protected void subSave(Resume resume, int index) {
        int saveIndex = -(++index);
        int copyLength = size - saveIndex;
        int destinationIndex = saveIndex + 1;
        System.arraycopy(storage, saveIndex, storage, destinationIndex, copyLength);
        storage[saveIndex] = resume;
    }

    @Override
    protected void subDelete(int index) {
        int indexPosition = index + 1;
        int copyLength = size - index;
        System.arraycopy(storage, indexPosition, storage, index, copyLength);
    }
}
