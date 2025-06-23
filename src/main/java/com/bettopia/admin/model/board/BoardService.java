package com.bettopia.admin.model.board;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
public class BoardService {

    @Autowired
    BoardDAO boardDAO;

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
            boardDAO.deleteBoard(boardId);
        }
    }
}
