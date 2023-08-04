enum MessageEnum {
  text("text"),
  image("image"),
  audio("audio"),
  video("video"),
  gif("gif");

  final String type;

  const MessageEnum(this.type);
}

// we can use Enhanced enum to get enum from a string or using extension like the following

extension ConvertMessage on String {
  MessageEnum toEnum() {
    switch (this) {
      case 'audio':
        return MessageEnum.audio;
      case 'image':
        return MessageEnum.image;
      case 'text':
        return MessageEnum.text;
      case 'gif':
        return MessageEnum.gif;
      case 'video':
        return MessageEnum.video;
      default:
        return MessageEnum.text;
    }
  }
}
