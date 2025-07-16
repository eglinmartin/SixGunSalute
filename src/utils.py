import numpy as np

from constants import Colour


def create_sine_wave(frequency: float, amplitude: float, duration: float, sampling_rate: float):
    """
    Returns a sine wave calculation  # TODO: Make parameter entry more user-friendly
    """
    t = np.linspace(0, duration, int(sampling_rate * duration), endpoint=False)
    sine = amplitude * np.sin(2 * np.pi * frequency * t)
    return sine


def loop_through_sequence(frame, sequence, frame_delay, counter):
    counter += 1
    if counter >= frame_delay:
        counter = 0
        frame += 1
        if frame == len(sequence):
            frame = 0

    return frame


def rgb(colour: Colour):
    """
    Converts hex code to rgb tuple and returns
    """
    return tuple(int(colour.value[i:i + 2], 16) for i in (0, 2, 4))
