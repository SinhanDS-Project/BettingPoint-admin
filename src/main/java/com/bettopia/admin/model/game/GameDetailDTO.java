package com.bettopia.admin.model.game;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class GameDetailDTO {
	private GameDTO game;
    private List<GameLevelDTO> levels;
}
