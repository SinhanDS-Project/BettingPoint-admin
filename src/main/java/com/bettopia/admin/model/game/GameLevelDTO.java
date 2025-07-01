package com.bettopia.admin.model.game;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class GameLevelDTO {
	private String uid; 
	private String game_uid;
	private String level;
	private double probability;
	private double reward;
}