import 'package:flutter/material.dart';

import 'colors.dart';

class ButtonIcon extends StatelessWidget {
  final IconData icon;

  const ButtonIcon({Key? key, required this.icon}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorPrimary,
                colorSecondary,
              ])),
      child: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }
}

class ButtonPrimary extends StatelessWidget {
  final String? name;
  final Function onTap;
  const ButtonPrimary({Key? key, this.name, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Color(0xFF003366),
          border: Border.all(
            width: 2,
            color: Color(0xFF003366),
          ),
        ),
        child: Text(
          "$name",
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class ButtonPrimaryNoRounded extends StatelessWidget {
  final String? name;
  final Function onTap;
  const ButtonPrimaryNoRounded({Key? key, this.name, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
           border: Border.all(
            width: 1,
            color: Colors.red
           )),
        child: Text(
          "$name",
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

class ButtonSecondary extends StatelessWidget {
  final String? name;
  final Function onTap;
  const ButtonSecondary({Key? key, this.name, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.purple,
          border: Border.all(
            width: 2,
            color: Colors.purple,
          ),
        ),
        child: Text(
          "$name",
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class ButtonDelete extends StatelessWidget {
  final String? name;
  final Function onTap;
  const ButtonDelete({Key? key, this.name, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.red,
          border: Border.all(
            width: 2,
            color: Colors.red,
          ),
        ),
        child: Text(
          "$name",
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class ButtonProcess extends StatelessWidget {
  final String? name;
  final Function onTap;
  const ButtonProcess({Key? key, this.name, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.yellow,
          border: Border.all(
            width: 2,
            color: Colors.yellow,
          ),
        ),
        child: Text(
          "$name",
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

class ButtonClose extends StatelessWidget {
  final String? name;
  final Function onTap;
  const ButtonClose({Key? key, this.name, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.black,
          border: Border.all(
            width: 2,
            color: Colors.black,
          ),
        ),
        child: Text(
          "$name",
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}


