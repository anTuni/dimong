package com.ssafy.dimong_be.interfaces.common;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class MypageDto implements Serializable {

	private Long userId;
	private String userNickname;
	private String userProfileImage;
	private final List<UserBadgeDto> userBadgeList = new ArrayList<>();
	private final List<MyDrawingDto> myDrawingList = new ArrayList<>();

	public void addUserBadgeDto(UserBadgeDto userBadgeDto) {
		userBadgeList.add(userBadgeDto);
	}

	public void addMyDrawingDto(MyDrawingDto myDrawingDto) {
		myDrawingList.add(myDrawingDto);
	}

}
