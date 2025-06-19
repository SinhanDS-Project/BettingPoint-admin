package com.bettopia.admin.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;


@Configuration
public class AmazonS3Config {

    @Value("${AMAZONPROPERTIES_ACCESSKEY}")
    private String accessKey;
    @Value("${AMAZONPROPERTIES_SECRETKEY}")
    private String secretKey;
    @Value("${AMAZONPROPERTIES_REGION}")
    private String region;

    @Bean
    public AmazonS3 amazonS3Client() {
        // AWS 자격증명 객체 생성
        BasicAWSCredentials awsCreds = new BasicAWSCredentials(accessKey, secretKey);
        // Amazon S3 클라이언트 빌드 (지정한 리전으로)
        return AmazonS3ClientBuilder.standard()
                .withCredentials(new AWSStaticCredentialsProvider(awsCreds))
                .withRegion(region)
                .build();
    }
}

