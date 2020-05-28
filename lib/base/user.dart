enum UserSex { male, female }

extension UserSexHelper on UserSex {
  int get value {
    switch (this) {
      case UserSex.female:
        return 0;
      default:
        return 1;
    }
  }
}

enum UserType { rentee, service, maintenance }

extension UserTypeHelper on UserType {
  int get value {
    switch (this) {
      case UserType.rentee:
        return 1;
      case UserType.maintenance:
        return 2;
      default:
        return 3;
    }
  }
}
