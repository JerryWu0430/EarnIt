import Foundation

import FirebaseDataConnect



public struct AnswerKey {
  
  public private(set) var id: UUID
  

  enum CodingKeys: String, CodingKey {
    
    case  id
    
  }
}

extension AnswerKey : Codable {
  public init(from decoder: any Decoder) throws {
    var container = try decoder.container(keyedBy: CodingKeys.self)
    let codecHelper = CodecHelper<CodingKeys>()

    
    self.id = try codecHelper.decode(UUID.self, forKey: .id, container: &container)
    
  }

  public func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      let codecHelper = CodecHelper<CodingKeys>()
      
      
      try codecHelper.encode(id, forKey: .id, container: &container)
      
      
    }
}

extension AnswerKey : Equatable {
  public static func == (lhs: AnswerKey, rhs: AnswerKey) -> Bool {
    
    if lhs.id != rhs.id {
      return false
    }
    
    return true
  }
}

extension AnswerKey : Hashable {
  public func hash(into hasher: inout Hasher) {
    
    hasher.combine(self.id)
    
  }
}

extension AnswerKey : Sendable {}



public struct QuestionKey {
  
  public private(set) var id: UUID
  

  enum CodingKeys: String, CodingKey {
    
    case  id
    
  }
}

extension QuestionKey : Codable {
  public init(from decoder: any Decoder) throws {
    var container = try decoder.container(keyedBy: CodingKeys.self)
    let codecHelper = CodecHelper<CodingKeys>()

    
    self.id = try codecHelper.decode(UUID.self, forKey: .id, container: &container)
    
  }

  public func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      let codecHelper = CodecHelper<CodingKeys>()
      
      
      try codecHelper.encode(id, forKey: .id, container: &container)
      
      
    }
}

extension QuestionKey : Equatable {
  public static func == (lhs: QuestionKey, rhs: QuestionKey) -> Bool {
    
    if lhs.id != rhs.id {
      return false
    }
    
    return true
  }
}

extension QuestionKey : Hashable {
  public func hash(into hasher: inout Hasher) {
    
    hasher.combine(self.id)
    
  }
}

extension QuestionKey : Sendable {}



public struct QuizAttemptKey {
  
  public private(set) var id: UUID
  

  enum CodingKeys: String, CodingKey {
    
    case  id
    
  }
}

extension QuizAttemptKey : Codable {
  public init(from decoder: any Decoder) throws {
    var container = try decoder.container(keyedBy: CodingKeys.self)
    let codecHelper = CodecHelper<CodingKeys>()

    
    self.id = try codecHelper.decode(UUID.self, forKey: .id, container: &container)
    
  }

  public func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      let codecHelper = CodecHelper<CodingKeys>()
      
      
      try codecHelper.encode(id, forKey: .id, container: &container)
      
      
    }
}

extension QuizAttemptKey : Equatable {
  public static func == (lhs: QuizAttemptKey, rhs: QuizAttemptKey) -> Bool {
    
    if lhs.id != rhs.id {
      return false
    }
    
    return true
  }
}

extension QuizAttemptKey : Hashable {
  public func hash(into hasher: inout Hasher) {
    
    hasher.combine(self.id)
    
  }
}

extension QuizAttemptKey : Sendable {}



public struct SubjectKey {
  
  public private(set) var id: UUID
  

  enum CodingKeys: String, CodingKey {
    
    case  id
    
  }
}

extension SubjectKey : Codable {
  public init(from decoder: any Decoder) throws {
    var container = try decoder.container(keyedBy: CodingKeys.self)
    let codecHelper = CodecHelper<CodingKeys>()

    
    self.id = try codecHelper.decode(UUID.self, forKey: .id, container: &container)
    
  }

  public func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      let codecHelper = CodecHelper<CodingKeys>()
      
      
      try codecHelper.encode(id, forKey: .id, container: &container)
      
      
    }
}

extension SubjectKey : Equatable {
  public static func == (lhs: SubjectKey, rhs: SubjectKey) -> Bool {
    
    if lhs.id != rhs.id {
      return false
    }
    
    return true
  }
}

extension SubjectKey : Hashable {
  public func hash(into hasher: inout Hasher) {
    
    hasher.combine(self.id)
    
  }
}

extension SubjectKey : Sendable {}



public struct UserAnswerKey {
  
  public private(set) var quizAttemptId: UUID
  
  public private(set) var questionId: UUID
  

  enum CodingKeys: String, CodingKey {
    
    case  quizAttemptId
    
    case  questionId
    
  }
}

extension UserAnswerKey : Codable {
  public init(from decoder: any Decoder) throws {
    var container = try decoder.container(keyedBy: CodingKeys.self)
    let codecHelper = CodecHelper<CodingKeys>()

    
    self.quizAttemptId = try codecHelper.decode(UUID.self, forKey: .quizAttemptId, container: &container)
    
    self.questionId = try codecHelper.decode(UUID.self, forKey: .questionId, container: &container)
    
  }

  public func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      let codecHelper = CodecHelper<CodingKeys>()
      
      
      try codecHelper.encode(quizAttemptId, forKey: .quizAttemptId, container: &container)
      
      
      
      try codecHelper.encode(questionId, forKey: .questionId, container: &container)
      
      
    }
}

extension UserAnswerKey : Equatable {
  public static func == (lhs: UserAnswerKey, rhs: UserAnswerKey) -> Bool {
    
    if lhs.quizAttemptId != rhs.quizAttemptId {
      return false
    }
    
    if lhs.questionId != rhs.questionId {
      return false
    }
    
    return true
  }
}

extension UserAnswerKey : Hashable {
  public func hash(into hasher: inout Hasher) {
    
    hasher.combine(self.quizAttemptId)
    
    hasher.combine(self.questionId)
    
  }
}

extension UserAnswerKey : Sendable {}



public struct UserStatisticKey {
  
  public private(set) var userId: String
  
  public private(set) var subjectId: UUID
  

  enum CodingKeys: String, CodingKey {
    
    case  userId
    
    case  subjectId
    
  }
}

extension UserStatisticKey : Codable {
  public init(from decoder: any Decoder) throws {
    var container = try decoder.container(keyedBy: CodingKeys.self)
    let codecHelper = CodecHelper<CodingKeys>()

    
    self.userId = try codecHelper.decode(String.self, forKey: .userId, container: &container)
    
    self.subjectId = try codecHelper.decode(UUID.self, forKey: .subjectId, container: &container)
    
  }

  public func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      let codecHelper = CodecHelper<CodingKeys>()
      
      
      try codecHelper.encode(userId, forKey: .userId, container: &container)
      
      
      
      try codecHelper.encode(subjectId, forKey: .subjectId, container: &container)
      
      
    }
}

extension UserStatisticKey : Equatable {
  public static func == (lhs: UserStatisticKey, rhs: UserStatisticKey) -> Bool {
    
    if lhs.userId != rhs.userId {
      return false
    }
    
    if lhs.subjectId != rhs.subjectId {
      return false
    }
    
    return true
  }
}

extension UserStatisticKey : Hashable {
  public func hash(into hasher: inout Hasher) {
    
    hasher.combine(self.userId)
    
    hasher.combine(self.subjectId)
    
  }
}

extension UserStatisticKey : Sendable {}



public struct UserKey {
  
  public private(set) var id: String
  

  enum CodingKeys: String, CodingKey {
    
    case  id
    
  }
}

extension UserKey : Codable {
  public init(from decoder: any Decoder) throws {
    var container = try decoder.container(keyedBy: CodingKeys.self)
    let codecHelper = CodecHelper<CodingKeys>()

    
    self.id = try codecHelper.decode(String.self, forKey: .id, container: &container)
    
  }

  public func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      let codecHelper = CodecHelper<CodingKeys>()
      
      
      try codecHelper.encode(id, forKey: .id, container: &container)
      
      
    }
}

extension UserKey : Equatable {
  public static func == (lhs: UserKey, rhs: UserKey) -> Bool {
    
    if lhs.id != rhs.id {
      return false
    }
    
    return true
  }
}

extension UserKey : Hashable {
  public func hash(into hasher: inout Hasher) {
    
    hasher.combine(self.id)
    
  }
}

extension UserKey : Sendable {}


