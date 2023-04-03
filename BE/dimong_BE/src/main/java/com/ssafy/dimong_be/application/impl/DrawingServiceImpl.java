package com.ssafy.dimong_be.application.impl;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ssafy.dimong_be.application.DrawingService;
import com.ssafy.dimong_be.application.exception.ErrorCode;
import com.ssafy.dimong_be.application.exception.business.EntityNotFoundException;
import com.ssafy.dimong_be.domain.model.drwaing.Drawing;
import com.ssafy.dimong_be.domain.model.drwaing.DrawingRepository;
import com.ssafy.dimong_be.interfaces.common.MyDrawingDto;
import com.ssafy.dimong_be.interfaces.dinosaur.DinosaurRecommendationResponseDto;
import com.ssafy.dimong_be.interfaces.drawing.DrawingResponseDto;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Transactional
@RequiredArgsConstructor
@Slf4j
public class DrawingServiceImpl implements DrawingService {

	private final DrawingRepository drawingRepository;

	@Override
	public List<Drawing> getDrawingList(Long userId) {
		return drawingRepository.findAllByUser_UserId(userId);
	}

	@Override
	public void saveDrawing(MyDrawingDto drawing) {
		drawingRepository.save(MyDrawingDto.toEntity(drawing));
	}

	@Override
	public DrawingResponseDto getDrawing(Long drawingId) {
		Drawing drawing = drawingRepository.findById(drawingId)
			.orElseThrow(() -> new EntityNotFoundException(
				"drawingId(" + drawingId + ")에 해당하는 그림이 없습니다.",
				ErrorCode.ENTITY_NOT_FOUND)
			);

		DrawingResponseDto drawingResponseDto = DrawingResponseDto.builder()
			.drawingId(drawingId)
			.drawingImageUrl(drawing.getDrawingImageUrl())
			.userId(drawing.getUserId())
			.build();

		drawingResponseDto.addSimilarList(
			DinosaurRecommendationResponseDto.fromEntity(drawing.getSimilarDinosaur1())
		);

		drawingResponseDto.addSimilarList(
			DinosaurRecommendationResponseDto.fromEntity(drawing.getSimilarDinosaur2())
		);

		drawingResponseDto.addSimilarList(
			DinosaurRecommendationResponseDto.fromEntity(drawing.getSimilarDinosaur3())
		);

		return drawingResponseDto;
	}

}
