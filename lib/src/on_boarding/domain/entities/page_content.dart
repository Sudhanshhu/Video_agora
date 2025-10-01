import 'package:equatable/equatable.dart';
import '../../../../core/utils/media_res.dart';

class PageContent extends Equatable {
  const PageContent({
    required this.image,
    required this.title,
    required this.description,
  });

  const PageContent.first()
      : this(
// Video Calling
          image: MediaRes.videoCalling,
          title: 'Seamless Video Calling',
          description:
              'Connect face-to-face with friends, colleagues, or classmates in real time with crystal-clear video calls.',
        );

  const PageContent.second()
      : this(
// Screen Sharing
          image: MediaRes.screenSharing,
          title: 'Share Your Screen',
          description:
              'Present your work, teach lessons, or collaborate on projects easily by sharing your screen instantly.',
        );

  const PageContent.third()
      : this(
// Mute
          image: MediaRes.videoEditing,
          title: 'One-Tap Mute Control',
          description:
              'Stay in control during calls—mute and unmute your microphone anytime with a single tap.',
        );

  final String image;
  final String title;
  final String description;

  @override
  List<Object?> get props => [image, title, description];
}
