package com.bettopia.admin.controller;

import com.amazonaws.services.s3.AmazonS3Client;
import com.bettopia.admin.model.aws.S3FileService;
import com.bettopia.admin.model.board.BoardDTO;
import com.bettopia.admin.model.board.BoardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/board")
public class BoardRestController {

    @Autowired
    private BoardService boardService;
    @Autowired
    private S3FileService s3FileService;

    @Autowired
    AmazonS3Client amazonS3;

    @Autowired
    @Qualifier("s3BucketName")
    private String bucketName;

    @GetMapping("/list")
    public List<BoardDTO> selectAll() {
        return boardService.selectAll();
    }

    @GetMapping("/detail/{boardId}")
    public BoardDTO selectById(@PathVariable String boardId) {
        return boardService.selectById(boardId);
    }

    @PostMapping("/insert")
    public String insertBoard(@RequestBody BoardDTO board, @RequestHeader("Authorization") String authHeader) {
//        String userId = authService.validateAndGetUserId(authHeader);
        String userId = "0";
        return boardService.insertBoard(board, userId);
    }

    @PutMapping("/update/{boardId}")
    public String updateBoard(@RequestBody BoardDTO board, @PathVariable String boardId) {
        return boardService.updateBoard(board, boardId);
    }

    @DeleteMapping("/delete/{boardId}")
    public void deleteBoard(@PathVariable String boardId) {
        boardService.deleteBoard(boardId);
    }

    // summernote 이미지 업로드 (S3 연동)
    @PostMapping(value = "/image-upload", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @ResponseBody
    public Map<String, Object> uploadImage(@RequestPart("image") MultipartFile file) {
        Map<String, Object> response = new HashMap<>();

        try {
            String imageUrl = s3FileService.uploadFile(file); // URL을 바로 받음
            String s3 = "https://"+bucketName+".s3." +amazonS3.getRegion()+".amazonaws.com/";
            response.put("url", s3+imageUrl);
            response.put("success", 1);
            response.put("message", "업로드 성공");
        } catch (Exception e) {
            e.printStackTrace();
            response.put("success", 0);
            response.put("message", "업로드 실패");
        }

        return response;
    }
}