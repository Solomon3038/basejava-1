package ru.javawebinar.basejava.util;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.io.FileUtils;
import ru.javawebinar.basejava.model.Resume;

import java.io.File;
import java.io.IOException;
import java.util.List;

public class ImageUtil {

    public static void saveImage(FileItem fi, String realSavePath) throws Exception {
        File file = new File(realSavePath);
        fi.write(file);
    }

    public static String getUuidForFileName(String fileName, String uuidName) {
        if (fileName.toUpperCase().endsWith(".GIF") ||
                fileName.toUpperCase().endsWith(".PNG") ||
                fileName.toUpperCase().endsWith(".JPG")) {
            return uuidName + fileName.substring(fileName.length() - 4);
        } else if (fileName.toUpperCase().endsWith(".JPEG")) {
            return uuidName + fileName.substring(fileName.length() - 5);
        }
        return null;
    }

    public static void deleteImage(String pathForDelete) {
        File file = new File(pathForDelete);
        if (file.exists()) {
            try {
                FileUtils.forceDelete(file);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    public static void clearAllImages(List<Resume> allSorted) {
        for (Resume resume : allSorted) {
            String realPath = resume.getRealSavePath();
            if (realPath != null) {
                File file = new File(realPath);
                if (file.exists()) {
                    try {
                        FileUtils.forceDelete(file);
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            }
        }
    }

    public static void checkImageInFolder(Resume resume) {
        String realPath = resume.getRealSavePath();
        if (realPath != null) {
            File file = new File(realPath);
            if (!file.exists()) {
                resume.setRealSavePath(null);
                resume.setImagePath("img/user.jpg");
            }
        }
    }
}
