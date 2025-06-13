//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

#define BACKGROUND_TASK_IDLE "idle"
#define BACKGROUND_TASK_QUEUED "queued"
#define BACKGROUND_TASK_RUNNING "running"
#define BACKGROUND_TASK_FINISHED "finished"
#define BACKGROUND_TASK_YIELDING "yielding"

/// must be returned if a task is not yield()ed or finish()ed
#define BACKGROUND_TASK_RETVAL_CONTINUE -1
/// must be returned if a task is yield()ed or finish()ed
#define BACKGROUND_TASK_RETVAL_YIELD -2
