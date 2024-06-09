using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ContactCursor : MonoBehaviour
{
   // Limits our maximum travel to keep the complexity down.
    public float maxSpeed = 15f;

    public float radius = 0.5f;

    // Remember to set this to include the layer your balls are on.
    public LayerMask collisionLayers; 

    Camera _camera;
    float _cameraPlane;

    // Cache camera and our distance from it, for positioning relative to cursor.
    void Start () {
        _camera = Camera.main;
        _cameraPlane = _camera.WorldToScreenPoint(transform.position).z;
    }

    void LateUpdate () {
        // Transform the mouse into a position on our travel plane.
        Vector3 mousePosition = Input.mousePosition;
        mousePosition.z = _cameraPlane;
        mousePosition = _camera.ScreenToWorldPoint(mousePosition);

        Vector3 offset = mousePosition - transform.position;
        Vector3 direction = offset.normalized;
        float maxDistance = Mathf.Min(offset.magnitude, maxSpeed * Time.deltaTime);

        Vector3 targetPosition = transform.position + direction * maxDistance;

        // Currently set to do 2 passes:
        // 1: Beeline toward the mouse until you hit something.
        // 2: Use any remaining movement to move perpendicular to the obstacle.
        // In my tests this was enough, but you can increase this
        // if you have more complex arrangements or a faster cursor.
        int limit = 2;
        for (int i = 0; i < limit; i++) {

            // Check for a collision in the direction we're trying to move.
            RaycastHit hit;    
            if (Physics.SphereCast(transform.position, radius, direction, out hit, maxDistance, collisionLayers)) {

                // Back up to closest non-intersecting point.
                // (Plus a small fudge factor for stability).
                offset = hit.point + radius * hit.normal - transform.position;                
                float distance = Vector3.Dot(offset, direction) - 0.001f;
                targetPosition = transform.position + direction * distance;

                transform.position = targetPosition;

                if (i + 1 == limit)
                    return;

                // Determine a new move to approach the cursor without
                // penetrating deeper into whatever we hit.
                maxDistance = Mathf.Max(maxDistance - distance, 0f);

                offset = mousePosition - transform.position;    

                // Make sure we don't overshoot the closest point on this line
                // to the mouse (prevents vibrating when close-but-mot-quite).
                distance = offset.sqrMagnitude;
                float forbidden = Vector3.Dot(offset, hit.normal);
                distance -= forbidden * forbidden;
                // Shouldn't happen with infinite-precision real numbers, 
                // but rounding errors happen in practice.
                if (distance < 0f) 
                    return;    
                maxDistance = Mathf.Min(maxDistance, Mathf.Sqrt(distance));                            

                // Calculate new movement direction.
                offset -= forbidden * hit.normal;
                offset.y = 0f;
                direction = offset.normalized;

                targetPosition = transform.position + direction * maxDistance;
            }
            else {
                // No collision! Complete the move.
                transform.position = targetPosition;
                return;
            }
        }
    }
}
