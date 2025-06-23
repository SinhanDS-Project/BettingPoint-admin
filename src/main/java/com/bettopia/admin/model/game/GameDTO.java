package com.bettopia.admin.model.game;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class GameDTO {
    private String uid;
    private String name;
    private String type;
    private String description;
    private String level;
    private String status;
    private double probability;
    private double reward;
}