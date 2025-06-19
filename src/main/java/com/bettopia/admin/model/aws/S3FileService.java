package com.bettopia.admin.model.aws;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.amazonaws.services.s3.AmazonS3Client;
import com.amazonaws.services.s3.model.ObjectMetadata;

@Service
public class S3FileService {

	@Autowired
	AmazonS3Client amazonS3; // 앞서 설정한 AmazonS3 빈 주입

	@Value("${AMAZONPROPERTIES_BUCKETNAME}")
	private String bucketName;

	// 단일 파일 업로드
	public String uploadFile(MultipartFile file, String dirName) {
		if (file.isEmpty())
			return null;
		String originalName = file.getOriginalFilename();
		// 폴더 경로/파일명 형태로 지정(폴더 없으면 그냥 파일명만)
		String key = (dirName != null && !dirName.isEmpty() ? dirName + "/" : "") + originalName;

		try (InputStream is = file.getInputStream()) {
			
			ObjectMetadata metadata = new ObjectMetadata();
			
			metadata.setContentLength(file.getSize());
			metadata.setContentType(file.getContentType());
			
			// S3에 파일 업로드
			amazonS3.putObject(bucketName, key, is, metadata);
		} catch (IOException e) {
			throw new RuntimeException("S3 파일 업로드 실패", e);
		}
		return key;
	}

	// 다중 파일 업로드
	public List<String> uploadFiles(MultipartFile[] files, String dirName) {
		List<String> uploadedKeys = new ArrayList<>();
		for (MultipartFile file : files) {
			String key = uploadFile(file, dirName);
			if (key != null) {
				uploadedKeys.add(key);
			}
		}
		return uploadedKeys;
	}
}
