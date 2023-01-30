package com.komorowski.backend.service;

import com.komorowski.backend.model.ImageModel;
import com.komorowski.backend.repository.ImageRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.zip.DataFormatException;
import java.util.zip.Deflater;
import java.util.zip.Inflater;

@Service
@RequiredArgsConstructor
public class ImageService {

    private final ImageRepository imageRepository;

    public Long uploadImage(MultipartFile file) {
        try {
            ImageModel img = new ImageModel(file.getOriginalFilename(),
                    file.getContentType(),
                    compressBytes(file.getBytes()));

            this.imageRepository.save(img);
            return img.getId();

        } catch (Exception ignored){
        }
        return null;
    }

    public byte[] getImage(Long id){
        ImageModel image = this.imageRepository.findById(id).orElseThrow();
        return decompressBytes(image.getPicByte());
    }

    public static byte[] compressBytes(byte[] data){
        Deflater deflater = new Deflater();
        deflater.setInput(data);
        deflater.finish();
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream(data.length);
        byte[] buffer = new byte[1024];
        while(!deflater.finished()){
            int count = deflater.deflate(buffer);
            outputStream.write(buffer, 0, count);
        }
        try {
            outputStream.close();
        } catch (IOException ignored) {
        }
        return outputStream.toByteArray();
    }

    public static byte[] decompressBytes(byte[] data){
        Inflater inflater = new Inflater();
        inflater.setInput(data);
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream(data.length);
        byte[] buffer = new byte[1024];
        try {
            while(!inflater.finished()){
                int count = inflater.inflate(buffer);
                outputStream.write(buffer, 0, count);
            }
            outputStream.close();
        } catch (DataFormatException | IOException ignored) {
        }
        return outputStream.toByteArray();
    }

}
