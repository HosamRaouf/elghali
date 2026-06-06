import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;
import '../../../core/theme/app_colors.dart';

String _colorToHex(Color color) {
  return '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
}

class DallahIcon extends StatelessWidget {
  final double size;
  final Color? color;

  const DallahIcon({super.key, this.size = 24, this.color});

  @override
  Widget build(BuildContext context) {
    final c = _colorToHex(color ?? AppColors.primary);
    final svgString = '''
    <svg width="$size" height="$size" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg">
      <path d="M8 12 C4 10 2 8 3 6 C4 4 7 5 9 8" stroke="$c" stroke-width="1.5" stroke-linecap="round" fill="none" />
      <path d="M9 8 C9 8 10 6 14 6 L18 6 C22 6 24 9 24 13 C24 19 20 24 16 25 C12 24 8 19 8 13 Z" 
        stroke="$c" stroke-width="1.5" fill="$c" fill-opacity="0.15" />
      <rect x="13" y="3" width="6" height="4" rx="1" stroke="$c" stroke-width="1.2" fill="$c" fill-opacity="0.2" />
      <ellipse cx="16" cy="3" rx="4" ry="1.5" stroke="$c" stroke-width="1.2" fill="$c" fill-opacity="0.3" />
      <circle cx="16" cy="1.5" r="1" fill="$c" />
      <path d="M24 10 C28 10 29 14 28 17 C27 19 25 20 24 19" stroke="$c" stroke-width="1.5" stroke-linecap="round" fill="none" />
      <ellipse cx="16" cy="25" rx="6" ry="2" stroke="$c" stroke-width="1.2" fill="$c" fill-opacity="0.2" />
      <path d="M11 14 C12 12 14 11 16 11 C18 11 20 12 21 14" stroke="$c" stroke-width="0.8" stroke-linecap="round" opacity="0.6" />
    </svg>
    ''';
    return SvgPicture.string(svgString, width: size, height: size);
  }
}

class OctagonalStar extends StatelessWidget {
  final double size;
  final Color? color;
  final bool filled;

  const OctagonalStar({super.key, this.size = 24, this.color, this.filled = false});

  @override
  Widget build(BuildContext context) {
    final c = _colorToHex(color ?? AppColors.primary);
    
    String star8Points = "";
    for (int i = 0; i < 16; i++) {
      final angle = (i * 22.5 - 11.25) * (math.pi / 180);
      final outerR = size / 2 - 1;
      final innerR = outerR * 0.5;
      final r = i % 2 == 0 ? outerR : innerR;
      final x = size / 2 + r * math.cos(angle - math.pi / 2);
      final y = size / 2 + r * math.sin(angle - math.pi / 2);
      star8Points += "$x,$y ";
    }

    final svgString = '''
    <svg width="$size" height="$size" viewBox="0 0 $size $size" xmlns="http://www.w3.org/2000/svg">
      <polygon points="$star8Points" fill="${filled ? c : "none"}" stroke="$c" stroke-width="1" stroke-linejoin="round" />
    </svg>
    ''';
    return SvgPicture.string(svgString, width: size, height: size);
  }
}

class CoffeeBeanMenu extends StatelessWidget {
  final double size;
  final Color? color;

  const CoffeeBeanMenu({super.key, this.size = 24, this.color});

  @override
  Widget build(BuildContext context) {
    final c = _colorToHex(color ?? AppColors.primary);
    final svgString = '''
    <svg width="$size" height="$size" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
      <ellipse cx="12" cy="7" rx="3" ry="5" fill="$c" fill-opacity="0.9" transform="rotate(-20 12 7)" />
      <line x1="12" y1="2.5" x2="12" y2="11.5" stroke="#1A0A00" stroke-width="0.8" transform="rotate(-20 12 7)" />
      <ellipse cx="7" cy="15" rx="3" ry="5" fill="$c" fill-opacity="0.7" transform="rotate(10 7 15)" />
      <line x1="7" y1="10.5" x2="7" y2="19.5" stroke="#1A0A00" stroke-width="0.8" transform="rotate(10 7 15)" />
      <ellipse cx="17" cy="15" rx="3" ry="5" fill="$c" fill-opacity="0.7" transform="rotate(-10 17 15)" />
      <line x1="17" y1="10.5" x2="17" y2="19.5" stroke="#1A0A00" stroke-width="0.8" transform="rotate(-10 17 15)" />
    </svg>
    ''';
    return SvgPicture.string(svgString, width: size, height: size);
  }
}

class CupIcon extends StatelessWidget {
  final double size;
  final Color? color;

  const CupIcon({super.key, this.size = 24, this.color});

  @override
  Widget build(BuildContext context) {
    final c = _colorToHex(color ?? AppColors.primary);
    final svgString = '''
    <svg width="$size" height="$size" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
      <path d="M10 4 C10 3 11 2 10 1" stroke="$c" stroke-width="1" stroke-linecap="round" opacity="0.6" />
      <path d="M14 4 C14 3 15 2 14 1" stroke="$c" stroke-width="1" stroke-linecap="round" opacity="0.6" />
      <path d="M5 7 L7 18 C7 19 8 20 9 20 L15 20 C16 20 17 19 17 18 L19 7 Z" fill="$c" fill-opacity="0.15" stroke="$c" stroke-width="1.4" />
      <path d="M19 9 C21 9 22 10 22 12 C22 14 21 15 19 15" stroke="$c" stroke-width="1.4" stroke-linecap="round" fill="none" />
      <ellipse cx="12" cy="20.5" rx="6" ry="1.5" stroke="$c" stroke-width="1.2" fill="$c" fill-opacity="0.1" />
    </svg>
    ''';
    return SvgPicture.string(svgString, width: size, height: size);
  }
}

class CoffeeBagCart extends StatelessWidget {
  final double size;
  final Color? color;

  const CoffeeBagCart({super.key, this.size = 24, this.color});

  @override
  Widget build(BuildContext context) {
    final c = _colorToHex(color ?? AppColors.primary);
    final svgString = '''
    <svg width="$size" height="$size" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
      <path d="M5 9 C5 8 6 7 7 7 L17 7 C18 7 19 8 19 9 L20 20 C20 21 19 22 18 22 L6 22 C5 22 4 21 4 20 Z" fill="$c" fill-opacity="0.15" stroke="$c" stroke-width="1.2" />
      <path d="M9 7 C9 5 10 4 12 4 C14 4 15 5 15 7" stroke="$c" stroke-width="1.5" stroke-linecap="round" fill="none" />
      <line x1="7" y1="11" x2="17" y2="11" stroke="$c" stroke-width="0.6" opacity="0.5" />
      <line x1="7" y1="14" x2="17" y2="14" stroke="$c" stroke-width="0.6" opacity="0.5" />
      <line x1="7" y1="17" x2="17" y2="17" stroke="$c" stroke-width="0.6" opacity="0.5" />
      <circle cx="12" cy="12.5" r="2" fill="$c" opacity="0.6" />
    </svg>
    ''';
    return SvgPicture.string(svgString, width: size, height: size);
  }
}

class ProfileIcon extends StatelessWidget {
  final double size;
  final Color? color;

  const ProfileIcon({super.key, this.size = 24, this.color});

  @override
  Widget build(BuildContext context) {
    final c = _colorToHex(color ?? AppColors.primary);
    final svgString = '''
    <svg width="$size" height="$size" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
      <circle cx="12" cy="8" r="4" stroke="$c" stroke-width="1.5" fill="$c" fill-opacity="0.15" />
      <path d="M4 20 C4 16 7.5 13 12 13 C16.5 13 20 16 20 20" stroke="$c" stroke-width="1.5" stroke-linecap="round" fill="none" />
      <path d="M10 13 L12 15 L14 13" stroke="$c" stroke-width="1" stroke-linecap="round" stroke-linejoin="round" />
    </svg>
    ''';
    return SvgPicture.string(svgString, width: size, height: size);
  }
}

class DallahLocationPin extends StatelessWidget {
  final double size;
  final Color? color;

  const DallahLocationPin({super.key, this.size = 32, this.color});

  @override
  Widget build(BuildContext context) {
    final c = _colorToHex(color ?? AppColors.primary);
    final svgString = '''
    <svg width="$size" height="$size" viewBox="0 0 32 40" fill="none" xmlns="http://www.w3.org/2000/svg">
      <path d="M16 40 C16 40 32 28 32 16 C32 7.16344 24.8366 0 16 0 C7.16344 0 0 7.16344 0 16 C0 28 16 40 16 40Z" fill="$c" fill-opacity="0.15" stroke="$c" stroke-width="1.5" />
      <circle cx="16" cy="16" r="12" fill="$c" fill-opacity="0.1" />
      <g transform="translate(8, 8) scale(0.5)">
        <path d="M8 12 C4 10 2 8 3 6 C4 4 7 5 9 8" stroke="$c" stroke-width="2" stroke-linecap="round" fill="none" />
        <path d="M9 8 C9 8 10 6 14 6 L18 6 C22 6 24 9 24 13 C24 19 20 24 16 25 C12 24 8 19 8 13 Z" 
          stroke="$c" stroke-width="2" fill="$c" />
        <rect x="13" y="3" width="6" height="4" rx="1" stroke="$c" stroke-width="1.5" />
      </g>
    </svg>
    ''';
    return SvgPicture.string(svgString, width: size, height: size * 1.25);
  }
}
