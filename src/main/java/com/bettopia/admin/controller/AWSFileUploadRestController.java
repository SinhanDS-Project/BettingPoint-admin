package com.bettopia.admin.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.bettopia.admin.model.aws.S3FileService;

@RestController
@RequestMapping("/api")  // API 경로의 예시
public class AWSFileUploadRestController {

    @Autowired
    private S3FileService s3FileService;

    @PostMapping(value="/uploadAjax")
    public List<String> uploadFilesViaAjax(@RequestParam("files") MultipartFile[] files) {
        // S3에 파일들 업로드하고 S3 키 목록을 결과로 반환
        List<String> uploadedKeys = s3FileService.uploadFiles(files);
        return uploadedKeys;
    }
}
