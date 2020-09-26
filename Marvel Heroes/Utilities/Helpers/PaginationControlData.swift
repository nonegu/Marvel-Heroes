//
//  PaginationControlData.swift
//  Marvel Heroes
//
//  Created by Ender on 26.09.2020.
//

import Foundation

struct PaginationControlData {
    var pageSize: Int = 20
    var currentPage: Int = 0
    var isLastPage = false
    var isLoading = false
    
    var canFetchNextPage: Bool {
        !isLoading && !isLastPage
    }
}
