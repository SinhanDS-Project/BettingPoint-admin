package com.bettopia.admin.model.contents;

import java.sql.Date;

import com.bettopia.admin.model.aws.S3ImagePathDeserializer;
import com.bettopia.admin.model.aws.S3ImageUrlSerializer;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Builder
@Data
public class BannerDTO {
	private String uid;
	private String title;
	
	@JsonSerialize(using = S3ImageUrlSerializer.class)
	@JsonDeserialize(using = S3ImagePathDeserializer.class)
	private String image_path;
	
	private String banner_link_url;
	private String description;
	private Date created_at;
	
	// 수정할 때 필요한 필드
	private String original_image_path;
}
