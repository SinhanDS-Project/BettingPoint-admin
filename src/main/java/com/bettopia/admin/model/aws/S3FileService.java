package com.bettopia.admin.model.aws;

import java.io.IOException;
import java.io.InputStream;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.amazonaws.services.s3.AmazonS3Client;
import com.amazonaws.services.s3.model.ObjectMetadata;

@Service
public class S3FileService {

	@Autowired
	AmazonS3Client amazonS3; // 앞서 설정한 AmazonS3 빈 주입

	@Autowired
    @Qualifier("s3BucketName")
    private String bucketName;

	// 단일 파일 업로드
	public String uploadFile(MultipartFile file) {
		if (file.isEmpty()) return null;
		
		// 파일 이름, 확장자
		String originalName = URLEncoder.encode(file.getOriginalFilename(), StandardCharsets.UTF_8);
		String extension = originalName.substring(originalName.lastIndexOf("."));
		
		// 파일명: UUID + 확장자 형태로 지정
	    String key = UUID.randomUUID() + extension;

		try (InputStream is = file.getInputStream()) {
			
			ObjectMetadata metadata = new ObjectMetadata();
			
			metadata.setContentLength(file.getSize());
			metadata.setContentType(file.getContentType());
			
			// S3에 파일 업로드
			amazonS3.putObject(bucketName, key, is, metadata);
			System.out.println("Uploaded S3 key: " + key);
		} catch (IOException e) {
			throw new RuntimeException("S3 파일 업로드 실패", e);
		}
		return key;
	}

	// 다중 파일 업로드
	public List<String> uploadFiles(MultipartFile[] files) {
		List<String> uploadedKeys = new ArrayList<>();
		for (MultipartFile file : files) {
			String key = uploadFile(file);
			if (key != null) {
				uploadedKeys.add(key);
			}
		}
		return uploadedKeys;
	}
}
