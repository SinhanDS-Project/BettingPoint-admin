package com.bettopia.admin.model.board;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public class BoardDAO {

    @Autowired
    private SqlSession sqlSession;

    String namespace = "com.bpoint.board.";

    public List<BoardDTO> selectAll() {
        return sqlSession.selectList(namespace + "selectAll");
    }

    public BoardDTO selectById(String boardId) {
        return sqlSession.selectOne(namespace + "selectById", boardId);
    }

    public String insertBoard(BoardDTO boardRequest, String userId) {
        String uid = UUID.randomUUID().toString().replace("-", "");
        BoardDTO boardResponse = BoardDTO.builder()
                .uid(uid)
                .title(boardRequest.getTitle())
                .content(boardRequest.getContent())
                .category(boardRequest.getCategory())
//                .board_img(boardRequest.getBoard_img())
                .user_uid(userId)
                .build();
        sqlSession.insert(namespace + "insert", boardResponse);
        return uid;
    }

    public String updateBoard(BoardDTO boardRequest, String boardId) {
        BoardDTO boardResponse = BoardDTO.builder()
                .uid(boardId)
                .title(boardRequest.getTitle())
                .content(boardRequest.getContent())
                .category(boardRequest.getCategory())
                .board_img(boardRequest.getBoard_img())
                .build();
        sqlSession.update(namespace + "update", boardResponse);
        return boardId;
    }

    public void deleteBoard(String boardId) {
        sqlSession.delete(namespace + "delete", boardId);
    }
}
