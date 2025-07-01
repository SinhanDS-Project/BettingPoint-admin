package com.bettopia.admin.controller;

import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import com.bettopia.admin.model.game.GameDTO;
import com.bettopia.admin.model.game.GameDetailDTO;
import com.bettopia.admin.model.game.GameLevelDTO;
import com.bettopia.admin.model.game.GameLevelService;
import com.bettopia.admin.model.game.GameService;

@RestController
@RequestMapping("/api/game")
public class GameRestController {

    @Autowired
    private GameService gameService;

    @Autowired
    private GameLevelService gameLevelService;

    // ✅ 전체 게임 목록 조회
    @GetMapping("/list")
    public List<GameDTO> getAllGames() {
        return gameService.selectAll();
    }

    // ✅ 특정 게임 조회 (게임 + 레벨 목록)
    @GetMapping("/{uid}")
    public GameDetailDTO getGameDetail(@PathVariable String uid) {
        GameDTO game = gameService.selectByUid(uid);
        List<GameLevelDTO> levels = gameLevelService.selectLevelsByGameUid(uid);

        return GameDetailDTO.builder()
                .game(game)
                .levels(levels)
                .build();
    }

    // ✅ 게임 + 게임레벨 등록
    @PostMapping("/create")
    public String createGameWithLevels(@RequestBody GameDetailDTO req) {
        GameDTO game = req.getGame();

        int gameResult = gameService.insert(game);

        int levelset = 0; // level 묶음(상, 중, 하)
        for (GameLevelDTO level : req.getLevels()) {
            level.setUid(UUID.randomUUID().toString().replace("-", ""));
            level.setGame_uid(game.getUid());
            levelset += gameLevelService.insert(level);
        }

        return (gameResult == 1 && levelset == req.getLevels().size()) ? 
					"게임 등록에 성공하였습니다." : "게임 등록에 실패하였습니다.";
    }

    // ✅ 게임 + 레벨 수정
    @PutMapping("/update")
    public String updateGameWithLevels(@RequestBody GameDetailDTO req) {
        GameDTO game = req.getGame();
        int gameResult = gameService.update(game);

        // 기존 레벨 삭제 후 다시 삽입
        gameLevelService.delete(game.getUid());

        int levelset = 0;
        for (GameLevelDTO level : req.getLevels()) {
            level.setUid(UUID.randomUUID().toString().replace("-", ""));
            level.setGame_uid(game.getUid());
            levelset += gameLevelService.insert(level);
        }

        return (gameResult == 1 && levelset == req.getLevels().size()) ? 
        			"게임 수정에 성공하였습니다." : "게임 수정에 실패하였습니다.";
    }

    // ✅ 게임 삭제 (레벨 먼저 삭제)
    @DeleteMapping("/delete/{uid}")
    public String deleteGame(@PathVariable String uid) { // 게임uid임
        gameLevelService.delete(uid);  // 레벨 먼저 삭제
        int result = gameService.delete(uid);  // 게임 삭제
        return result == 1 ? "게임 삭제에 성공하였습니다." : "게임 삭제에 실패하였습니다.";
    }
}
