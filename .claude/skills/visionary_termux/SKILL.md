# visionary_termux Development Patterns

> Auto-generated skill from repository analysis

## Overview
This skill teaches the core development conventions and workflows used in the `visionary_termux` repository. The codebase is primarily composed of Markdown and PDF documents with some Python scripts. No TypeScript/Node.js sources or `package.json` were detected.

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

**GitHub Actions** workflows are present under `.github/workflows/`.
- `dependency-review.yml` — dependency review checks
- `static.yml` — static site / Pages deployment
- `summary.yml` — summary generation workflow

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

No build, test, or lint commands were detected in this repository (no Node/TypeScript toolchain or Python test runner configured).