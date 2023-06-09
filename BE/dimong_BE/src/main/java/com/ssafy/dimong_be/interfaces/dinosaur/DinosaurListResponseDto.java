package com.ssafy.dimong_be.interfaces.dinosaur;

import java.io.Serializable;

import com.ssafy.dimong_be.domain.model.dinosaur.Dinosaur;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
// @RequiredArgsConstructor
// @NoArgsConstructor
public class DinosaurListResponseDto implements Serializable {

	private Long dinosaurId;
	private String dinosaurImageUrl;
	private String dinosaurName;
	private String dinosaurTaste;
	private boolean isCollected;

	public static DinosaurListResponseDto fromEntity(Dinosaur dinosaur) {
		return DinosaurListResponseDto.builder()
			.dinosaurId(dinosaur.getDinosaurId())
			.dinosaurImageUrl(dinosaur.getDinosaurImageUrl())
			.dinosaurName(dinosaur.getDinosaurName())
			.dinosaurTaste(dinosaur.getDinosaurTaste())
			.isCollected(dinosaur.isCollected())
			.build();
	}

}
