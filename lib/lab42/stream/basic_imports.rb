# frozen_string_literal: true
require_relative '../stream'
Stream = Lab42::Stream
EmptyStream = Lab42::EmptyStream
Kernel.send :include, Lab42::Stream::BasicClassMethods
# SPDX-License-Identifier: AGPL-3.0-or-later
