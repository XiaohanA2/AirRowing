import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraUtils {
  CameraController? controller;
  List<CameraDescription> cameras = [];
  bool isCameraInitialized = false;
  CameraDescription? currentCamera;

  /// 初始化可用的摄像头列表并设置当前摄像头。
  Future<void> initCameras() async {
    // 请求权限
    await _requestPermission();

    // 获取可用的摄像头列表
    cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      // 默认使用后置摄像头
      await setCamera(cameras.firstWhere(
              (camera) => camera.lensDirection == CameraLensDirection.back,
          orElse: () => cameras.first));
    }
  }

  /// 设置并初始化指定的摄像头。
  Future<void> setCamera(CameraDescription cameraDescription) async {
    currentCamera = cameraDescription;
    controller = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    await controller?.initialize();
    isCameraInitialized = controller?.value.isInitialized ?? false;
  }

  /// 请求摄像头权限。
  Future<bool> _requestPermission() async {
    // 检查摄像头权限状态, 如果已授权则直接返回
    if (await Permission.camera.isGranted) {
      return true;
    }

    PermissionStatus status = await Permission.camera.request();
    // 这里可以根据项目需求，添加对权限状态的判断和处理
    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      // 用户拒绝了权限请求
      print('用户拒绝了摄像头权限请求');
    } else if (status.isPermanentlyDenied) {
      // 用户拒绝了权限请求并选择了不再询问
      print('用户永久拒绝了摄像头权限请求');
    }

    return false;
  }

  /// 切换摄像头。
  Future<void> toggleCamera() async {
    if (cameras.length > 1) {
      var newIndex = cameras.indexOf(currentCamera!) + 1;
      if (newIndex >= cameras.length) {
        newIndex = 0;
      }
      await setCamera(cameras[newIndex]);
    }
  }

  /// 拍照并返回图片文件的路径。
  Future<String?> takePicture() async {
    if (!isCameraInitialized || controller!.value.isTakingPicture ?? true) {
      // 如果摄像头未初始化或正在拍照，则不执行拍照操作
      return null;
    }

    final XFile file = await controller!.takePicture();
    return file.path;
  }

  /// 开始录制视频。
  Future<void> startVideoRecording() async {
    if (!isCameraInitialized || controller!.value.isRecordingVideo ?? false) {
      // 如果摄像头未初始化或正在录制，则不执行录制操作
      return;
    }

    await controller!.startVideoRecording();
  }

  /// 停止录制视频并返回视频文件的路径。
  Future<String?> stopVideoRecording() async {
    if (!isCameraInitialized || !(controller?.value.isRecordingVideo ?? true)) {
      // 如果摄像头未初始化或未在录制，则不执行停止录制操作
      return null;
    }

    final XFile file = await controller!.stopVideoRecording();
    return file.path;
  }

  /// 释放摄像头控制器资源。
  Future<void> disposeCamera() async {
    isCameraInitialized = false;
    await controller?.dispose();
  }
}
