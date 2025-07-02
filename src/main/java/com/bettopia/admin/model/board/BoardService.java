package com.bettopia.admin.model.board;

import com.amazonaws.services.s3.AmazonS3Client;
import com.bettopia.admin.model.aws.S3FileService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Service
public class BoardService {

    @Autowired
    BoardDAO boardDAO;

    @Autowired
    private S3FileService s3FileService;

    @Autowired
    @Qualifier("s3BucketName")
    private String bucketName;

    @Autowired
    AmazonS3Client amazonS3;

    public List<BoardDTO> selectAll() {
        return boardDAO.selectAll();
    }

    public BoardDTO selectById(String boardId) {
        return boardDAO.selectById(boardId);
    }

    public String insertBoard(BoardDTO boardRequest, String userId) {
        return boardDAO.insertBoard(boardRequest, userId);
    }

    public String updateBoard(BoardDTO boardRequest, String boardId) {
        BoardDTO board = boardDAO.selectById(boardId);
        if(board != null) {
            return boardDAO.updateBoard(boardRequest, boardId);
        }
        return null;
    }

    public void deleteBoard(String boardId) {
        BoardDTO board = boardDAO.selectById(boardId);
        if(board != null) {
            // 본문 HTML에서 이미지 URL 추출 → S3에서 삭제Add commentMore actions
            String html = board.getContent();
            if (html != null && html.toLowerCase().contains("<img")) {
                // 대소문자 무시, img 태그의 src="..." 부분만 뽑는 정규식
                Pattern p = Pattern.compile("<img[^>]+src=[\"']([^\"']+)[\"']", Pattern.CASE_INSENSITIVE);
                Matcher m = p.matcher(html);

                // S3 URL prefix 계산
                String prefix = "https://" + bucketName + ".s3." + amazonS3.getRegion() + ".amazonaws.com/";
                while (m.find()) {
                    String imageUrl = m.group(1);
                    if (imageUrl.startsWith(prefix)) {
                        String key = imageUrl.substring(prefix.length());
                        s3FileService.deleteObject(key);
                    }
                }
            }

            boardDAO.deleteBoard(boardId);
        }
    }


}
