package com.bettopia.admin.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.bettopia.admin.model.aws.S3FileService;

@Controller
public class AWSFileUploadController {
	
	@Autowired
	S3FileService s3FileService;  // S3 업로드 처리를 담당하는 서비스
	
	@GetMapping("/fileupload")
	public String fileUploadPage(Model model) { 
		return "aws_s3/fileUpload";
	}
	

    // 단일 파일 업로드 처리 엔드포인트
    @PostMapping("/uploadFormSingle")
    public String uploadSingleFile(@RequestParam("file") MultipartFile file, Model model) {
        if (!file.isEmpty()) {
            String key = s3FileService.uploadFile(file, ""); // 기본 경로에 업로드
            model.addAttribute("message", "파일 업로드 성공: " + key);
        }
        return "aws_s3/uploadResult"; // 업로드 결과를 보여줄 JSP 뷰 이름
    }

    // 다중 파일 업로드 처리 엔드포인트
    @PostMapping("/uploadFormMulti")
    public String uploadMultipleFiles(@RequestParam("files") MultipartFile[] files, Model model) {
        if (files != null && files.length > 0) {
            List<String> keys = s3FileService.uploadFiles(files, "");
            model.addAttribute("message", "업로드 성공 - 총 " + keys.size() + "개 파일");
            model.addAttribute("fileKeys", keys);
        }
        return "aws_s3/uploadResult";
    }
	
}
