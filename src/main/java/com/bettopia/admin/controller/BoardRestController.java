package com.bettopia.admin.controller;

import com.bettopia.admin.model.board.BoardDTO;
import com.bettopia.admin.model.board.BoardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/board")
public class BoardRestController {

    @Autowired
    private BoardService boardService;

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
}