//
//  ErrorMessage.swift
//  Weather
//
//  Created by 김원기 on 2022/08/28.
//

// http status code 가 200 이라면 날씨를 출력하고
// 그 외에 코드는 오류이기 떄문에 alert 창으로 오류를 출력하는 코드 작성
// 즉, 에러 메시지 json 데이터를 매핑할 수 있는 구조체 정의

import Foundation

struct ErrorMessage: Codable {
    let message: String
}
