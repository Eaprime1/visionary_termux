```markdown
# visionary_termux Development Patterns

> Auto-generated skill from repository analysis

## Overview
This skill teaches the core development conventions and workflows used in the `visionary_termux` TypeScript codebase. It covers file naming, import/export styles, commit patterns, and testing practices, providing clear examples and actionable commands for efficient collaboration and code quality.

## Coding Conventions

### File Naming
- **PascalCase** is used for file names.
  - Example: `MyComponent.ts`, `UserService.ts`

### Import Style
- **Relative imports** are preferred.
  - Example:
    ```typescript
    import { UserService } from './UserService';
    ```

### Export Style
- **Named exports** are used instead of default exports.
  - Example:
    ```typescript
    // UserService.ts
    export function getUser(id: string) { ... }
    ```

### Commit Patterns
- **Freeform commit messages** with no strict prefixing.
- Average commit message length: ~72 characters.
  - Example:  
    ```
    Add initial implementation for user authentication flow
    ```

## Workflows

_No automated workflows detected in this repository._

## Testing Patterns

- **Testing Framework:** Not explicitly detected.
- **Test File Naming:** Test files follow the `*.test.*` pattern.
  - Example: `UserService.test.ts`
- **Typical Test Structure:**  
  ```typescript
  // UserService.test.ts
  import { getUser } from './UserService';

  describe('getUser', () => {
    it('returns user data for a valid ID', () => {
      // test implementation
    });
  });
  ```

## Commands

| Command | Purpose |
|---------|---------|
| /test   | Run all test files matching `*.test.*` pattern |
| /lint   | Lint the codebase for style and syntax issues (if linter configured) |
| /build  | Build the TypeScript project (if build script configured) |

```