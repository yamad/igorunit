================
Design Decisions
================

The first iteration of IgorUnit was based off of a macro language that
generated Igor code using the Python language. This method made some
things a bit easier because the Python processing step functioned like
a preprocessor macro expansion stage. However, the test code was so
far removed from the Igor environment itself that it was cumbersome to
use.

While working on this version, I was contacted by Adam Light from
WaveMetrics. After posting on the IgorExchange web forums that I was
working on a unit testing framework for Igor, he shared the code for a
unit testing framework used internally at WaveMetrics.

The second iteration of IgorUnit is the result of the object-oriented
style and modular approach used in the first IgorUnit along with
Igor-integrated design of Adam Light's testing framework.

IgorUnit has also been a place to try out some advanced programming
features of the Igor language. Some experiments have been more
successful than others. In general, a premium was placed on
modularity. I have mimicked an object system in most cases using
structures. Because of the limitations on structures in Igor 6.2,
objects do not fall out naturally. The jury is still out on whether
this design has any real benefits in the Igor language.
