package com.bettopia.admin.controller;

import com.bettopia.admin.model.game.GameDTO;
import com.bettopia.admin.model.game.GameService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/admin/game")
public class GameRestController {

    @Autowired
    private GameService gameService;

    // 전체조회
    @GetMapping("/list")
    public List<GameDTO> getGameList() {
        return gameService.getAll();
    }

    // 게임등록(POST)
    @PostMapping("/create")
    public String insertGame(@RequestBody GameDTO dto) {
        dto.setUid(UUID.randomUUID().toString());  // UID 직접 생성
        int result = gameService.create(dto);
        return result == 1 ? "success" : "fail";
    }

    // 게임 수정 (PUT)
    @PutMapping("/update")
    public String updateGame(@RequestBody GameDTO dto) {
        int result = gameService.update(dto);
        return result == 1 ? "success" : "fail";
    }


 
    // 게임 삭제 (AJAX DELETE)
    @DeleteMapping("/delete/{uid}")
    public String deleteGame(@PathVariable String uid) {
        int result = gameService.removeByUid(uid); 
        return result == 1 ? "success" : "fail";
    }
}