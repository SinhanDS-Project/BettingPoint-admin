package com.bettopia.admin.model.game;

import java.sql.Date;

import com.bettopia.admin.model.aws.S3ImagePathDeserializer;
import com.bettopia.admin.model.aws.S3ImageUrlSerializer;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

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
    
    @JsonSerialize(using = S3ImageUrlSerializer.class)
    @JsonDeserialize(using = S3ImagePathDeserializer.class)
    private String game_img;
    
    private String status;
    private Date created_at;
}